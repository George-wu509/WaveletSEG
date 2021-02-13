function varargout = run2_parameters(varargin)
% RUN1_PARAMETERS MATLAB code for run1_parameters.fig
%      RUN1_PARAMETERS, by itself, creates a new RUN1_PARAMETERS or raises the existing
%      singleton*.
%
%      H = RUN1_PARAMETERS returns the handle to a new RUN1_PARAMETERS or the handle to
%      the existing singleton*.
%
%      RUN1_PARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUN1_PARAMETERS.M with the given input arguments.
%
%      RUN1_PARAMETERS('Property','Value',...) creates a new RUN1_PARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before run1_parameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to run1_parameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help run1_parameters

% Last Modified by GUIDE v2.5 28-May-2018 16:52:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @run2_parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @run2_parameters_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Outputs from this function are returned to the command line.
function varargout = run2_parameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

%% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);
guidata(hObject, handles);
image_no= get(handles.popupmenu1,'Value');
time_no = 1;
t = 1;

%{
%% Default load first image information
d_fol = data_folder{1};
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
end
load(d_fol);
load([data_folder{image_no} 'sta.mat']);
time_no = 1; %str2num(get(handles.edit4,'String'));
time_no = max(min(max(io.t_mm),time_no),min(io.t_mm));
handles.time_no = time_no;

s_fol = [data_folder{image_no} 'stack' num2str(p.id.seg_method) '_t' num2str(time_no(1)) '.mat'];

if ispc ==1
    s_fol(findstr(s_fol, '/'))='\';
end
if exist(s_fol,'file')~=0
    load(s_fol);
end
handles.NFstk = NFstk;
if exist('coloroverlay','var')~=0
    handles.coloroverlay = coloroverlay;
end

%{
if exist('xyzintsegdat_nororate','var')==1
    xyzintsegdat = seg_result.xyzintsegdat_nororate;
else
    seg_result.xyzintsegdat_nororate = xyzintsegdat;
    save([data_folder{image_no} 'stack' num2str(p.id.seg_method) '_t' num2str(t) '.mat'],'seg_result','-append');
end
%}


% ----------- rotate ------------
%{
    if isfield(seg_result,'nucle_prop_nororate')==1
        xyzintsegdat = seg_result.xyzintsegdat_nororate;
    else
        seg_result.xyzintsegdat_nororate = xyzintsegdat;
        save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'seg_result','-append');
    end

    % delete nodueli from delete_list  [George]
    nucle_prop = delete_list(nucle_prop,p.nucle_delete_list);
    xyz_n = size(nucle_prop,1);

    % modify nuclei number in every dataset
    if size(seg_result.cf_center_xyzi,1) - xyz_n ~=0||size(xyzintsegdat,1) ~= xyz_n || p.modify_nuclei_list ==1
        cf_center_xyzi = zeros(xyz_n,10);xyzintsegdat_temp = zeros(xyz_n,size(xyzintsegdat,2));
        shape_class_temp = zeros(1,xyz_n);shape_class_abnormal_temp = zeros(1,xyz_n);
        shape_feature_temp = zeros(12,xyz_n);
        for kk=1:xyz_n
            nn = find(seg_result.cf_center_xyzi(:,1)==nucle_prop(kk,1));
            if isempty(nn)~=1
                cf_center_xyzi(kk,:) = seg_result.cf_center_xyzi(nn,:);
                xyzintsegdat_temp(kk,:) = xyzintsegdat(nn,:);
                shape_class_temp(1,kk) = shape_class(1,nn);
                shape_class_abnormal_temp(1,kk) = shape_class_abnormal(1,nn);
                shape_feature_temp(:,kk) = shape_feature(:,nn);
            end
        end
        xyzintsegdat = xyzintsegdat_temp;
        shape_class = shape_class_temp;
        shape_class_abnormal = shape_class_abnormal_temp;
        seg_result.cf_center_xyzi = cf_center_xyzi;
        shape_feature = shape_feature_temp;
        save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'seg_result','-append');
        save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'xyzintsegdat','-append');
        clear seg_result xyzintsegdat_temp cf_center_xyzi
    end
    height_level = get_height_level(nucle_prop(:,4));
    [nucle_prop,p] = rotate_fun(nucle_prop,[p.rotate_angle 0],p,[mean(nucle_prop(:,2:3)) 0],0);
    nucle_prop = update3D(nucle_prop,p);
    save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'nucle_prop','height_level','-append');
    var = whos('-file',[data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat']);
    for ii=1:size(var,1)
        if strcmp(var(ii).name, 'nucle_coordination')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'nucle_coordination');
            nucle_coordination = nucle_coordination_update(nucle_coordination,nucle_prop,height_level,p);
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'nucle_coordination','-append');
        end
        if strcmp(var(ii).name, 'xyzintsegdat')==1
            xyzintsegdat(:,1:3) = [nucle_prop(:,3) nucle_prop(:,2) nucle_prop(:,4)];
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'xyzintsegdat','-append');
        end                    
    end

    var = whos('-file',[data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat']);
    for ii=1:size(var,1)
        if strcmp(var(ii).name, 'nucle_prop_time')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_prop_time');
            nucle_prop_time{t} = nucle_prop;
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_prop_time','-append');
        end
        if strcmp(var(ii).name, 'nucle_coordination_time')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_coordination_time');
            nucle_coordination_time{t} = nucle_coordination;
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_coordination_time','-append');
        end
        if strcmp(var(ii).name, 'xyzintsegdat_time')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'xyzintsegdat_time');
            xyzintsegdat_time{t} = xyzintsegdat;
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'xyzintsegdat_time','-append');
        end                   
    end
%}
% ----------- rotate ------------


%}



% Update handles structure
guidata(hObject, handles);

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% find p.mat in [function] folder
%{
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
if exist(savefolder,'file')~=0
    load(savefolder);
else
    exit;
end
%
% Hint: delete(hObject) closes the figure
now_image=0;   % [George] on Jan.1  
if now_image ==0
    io.p.id_x1=str2double(get(handles.edit1,'String'));
    io.p.id_y1=str2double(get(handles.edit2,'String'));
    io.p.id_z1=str2double(get(handles.edit3,'String'));
    io.p.id_noisemin=str2double(get(handles.edit4,'String'));
    io.p.id_noisemax=str2double(get(handles.edit5,'String'));
    io.p.id_dist=str2double(get(handles.edit11,'String'));
    io.p.id_r=str2double(get(handles.edit6,'String'));
    io.p.id_distniegh=str2double(get(handles.edit7,'String'));
    io.p.id_PHHcutoff=str2double(get(handles.edit8,'String'));
    io.p.id_divcut=str2double(get(handles.edit9,'String'));
    
    io.p.otsu.thre_value=str2double(get(handles.edit15,'String'));
    io.p.otsu.gauss_size=str2double(get(handles.edit13,'String'));
    io.p.otsu.gauss_sigma=str2double(get(handles.edit14,'String'));
    io.p.otsu.imsharpen_radius=str2double(get(handles.edit16,'String'));
    io.p.otsu.imsharpen_amount=str2double(get(handles.edit17,'String'));
    io.p.otsu.winer=str2double(get(handles.edit18,'String'));
    io.p.otsu.deconv_len=str2double(get(handles.edit19,'String'));
    io.p.otsu.deconv_theta=str2double(get(handles.edit32,'String'));
    io.p.otsu.deconv_nsr=str2double(get(handles.edit33,'String'));
    
    io.p.ds.alpha=str2double(get(handles.edit21,'String'));
    io.p.ds.beta=str2double(get(handles.edit22,'String'));
    io.p.ds.gamma=str2double(get(handles.edit23,'String'));
    io.p.ds.epsilon=str2double(get(handles.edit24,'String'));
    io.p.ds.delta=str2double(get(handles.edit25,'String'));
    io.p.ds.sigmagradient=str2double(get(handles.edit26,'String'));
    io.p.ds.diffuse_iterations=str2double(get(handles.edit27,'String'));
    io.p.ds.kappa1=str2double(get(handles.edit28,'String'));
    io.p.ds.kappa2=str2double(get(handles.edit29,'String'));
    io.p.ds.gauss_filter_siz=str2double(get(handles.edit30,'String'));
    io.p.ds.gauss_filter_fit=str2double(get(handles.edit31,'String')); 
    io.p.id.radius=str2double(get(handles.edit34,'String'));
    io.p.id.xy_length = io.p.id.radius/io.resolution_xy;
    io.p.id.z_length = io.p.id.radius/io.resolution_z;
    est_wlet = io.p.id.xy_length*0.26;
    
    io.p.id.wavelet_on = get(handles.checkbox4,'Value');
    if io.p.id.wavelet_on ==1
        io.p.id.wavelet_scale = est_wlet*3/4 : est_wlet*1/4 :est_wlet*5/4;  
    else
        A = str2double(get(handles.edit12,'String'));
        if isempty(find(A==','))==0
            B = strsplit(A,',');
            for bi=1:size(B,2)
                C(1,bi) = str2double(B{1,bi}); 
            end
            io.p.id.wavelet_scale_input=C;
        end
    end

    io.p.otsu.otsu_on = get(handles.checkbox9,'Value');
    mtd = [];
    if get(handles.checkbox1,'Value')==1;mtd = [mtd 1];end
    if get(handles.checkbox2,'Value')==1;mtd = [mtd 2];end
    if get(handles.checkbox3,'Value')==1;mtd = [mtd 3];end
    if get(handles.checkbox8,'Value')==1;mtd = [mtd 4];end
    io.p.id.seg_method = mtd;
    
    % find p.mat in [function] folder
    rootfolder = pwd;
    savefolder = [rootfolder '/[functions]/io.mat'];
    if ispc ==1
        savefolder(findstr(savefolder, '/'))='\';
    end
    if exist(savefolder,'file')~=0
        save(savefolder,'io','-append');
    end
    
    % update all p.io using new parameters in data folders
    for i=1:size(data_folder,2)
            d_fol = data_folder{i};
            if ispc ==1
                d_fol(findstr(d_fol, '/'))='\';
            end       
        if exist([d_fol 'p.mat'],'file')~=0
            load([d_fol 'p.mat']);

    p.id_x1=str2double(get(handles.edit1,'String'));
    p.id_y1=str2double(get(handles.edit2,'String'));
    p.id_z1=str2double(get(handles.edit3,'String'));
    p.id_noisemin=str2double(get(handles.edit4,'String'));
    p.id_noisemax=str2double(get(handles.edit5,'String'));
    p.id_dist=str2double(get(handles.edit11,'String'));
    p.id_r=str2double(get(handles.edit6,'String'));
    p.id_distniegh=str2double(get(handles.edit7,'String'));
    p.id_PHHcutoff=str2double(get(handles.edit8,'String'));
    p.id_divcut=str2double(get(handles.edit9,'String'));
    
    p.otsu.thre_value=str2double(get(handles.edit15,'String'));
    p.otsu.gauss_size=str2double(get(handles.edit13,'String'));
    p.otsu.gauss_sigma=str2double(get(handles.edit14,'String'));
    p.otsu.imsharpen_radius=str2double(get(handles.edit16,'String'));
    p.otsu.imsharpen_amount=str2double(get(handles.edit17,'String'));
    p.otsu.winer=str2double(get(handles.edit18,'String'));
    p.otsu.deconv_len=str2double(get(handles.edit19,'String'));
    p.otsu.deconv_theta=str2double(get(handles.edit32,'String'));
    p.otsu.deconv_nsr=str2double(get(handles.edit33,'String'));
    
    p.ds.alpha=str2double(get(handles.edit21,'String'));
    p.ds.beta=str2double(get(handles.edit22,'String'));
    p.ds.gamma=str2double(get(handles.edit23,'String'));
    p.ds.epsilon=str2double(get(handles.edit24,'String'));
    p.ds.delta=str2double(get(handles.edit25,'String'));
    p.ds.sigmagradient=str2double(get(handles.edit26,'String'));
    p.ds.diffuse_iterations=str2double(get(handles.edit27,'String'));
    p.ds.kappa1=str2double(get(handles.edit28,'String'));
    p.ds.kappa2=str2double(get(handles.edit29,'String'));
    p.ds.gauss_filter_siz=str2double(get(handles.edit30,'String'));
    p.ds.gauss_filter_fit=str2double(get(handles.edit31,'String'));
    
    p.id.radius=str2double(get(handles.edit34,'String'));
    p.id.xy_length = io.p.id.radius/io.resolution_xy;
    p.id.z_length = io.p.id.radius/io.resolution_z;
    est_wlet = io.p.id.xy_length*0.26;
    
    p.id.wavelet_on = get(handles.checkbox4,'Value');
    if p.id.wavelet_on ==1
        p.id.wavelet_scale = est_wlet*3/4 : est_wlet*1/4 :est_wlet*5/4;  
    else
        A = str2double(get(handles.edit12,'String'));
        if isempty(find(A==','))==0
            B = strsplit(A,',');
            for bi=1:size(B,2)
                C(1,bi) = str2double(B{1,bi}); 
            end
            p.id.wavelet_scale_input=C;
        end
    end    
    
    p.otsu.otsu_on = get(handles.checkbox9,'Value');
    mtd = [];
    if get(handles.checkbox1,'Value')==1;mtd = [mtd 1];end
    if get(handles.checkbox2,'Value')==1;mtd = [mtd 2];end
    if get(handles.checkbox3,'Value')==1;mtd = [mtd 3];end
    if get(handles.checkbox8,'Value')==1;mtd = [mtd 4];end
    p.id.seg_method = mtd;

            % find p.mat in [function] folder
            if exist([d_fol 'p.mat'],'file')~=0
                save([d_fol 'p.mat'],'p','-append');
            end
        end  
    end
    
    
else
    d_fol = data_folder{now_image};
    if ispc ==1
        d_fol(findstr(d_fol, '/'))='\';
    end
    load([d_fol 'p.mat']);
    
    p.id_x1=str2double(get(handles.edit1,'String'));
    p.id_y1=str2double(get(handles.edit2,'String'));
    p.id_z1=str2double(get(handles.edit3,'String'));
    p.id_noisemin=str2double(get(handles.edit4,'String'));
    p.id_noisemax=str2double(get(handles.edit5,'String'));
    p.id_dist=str2double(get(handles.edit11,'String'));
    p.id_r=str2double(get(handles.edit6,'String'));
    p.id_distniegh=str2double(get(handles.edit7,'String'));
    p.id_PHHcutoff=str2double(get(handles.edit8,'String'));
    p.id_divcut=str2double(get(handles.edit9,'String'));
    
    p.otsu.thre_value=str2double(get(handles.edit15,'String'));
    p.otsu.gauss_size=str2double(get(handles.edit13,'String'));
    p.otsu.gauss_sigma=str2double(get(handles.edit14,'String'));
    p.otsu.imsharpen_radius=str2double(get(handles.edit16,'String'));
    p.otsu.imsharpen_amount=str2double(get(handles.edit17,'String'));
    p.otsu.winer=str2double(get(handles.edit18,'String'));
    p.otsu.deconv_len=str2double(get(handles.edit19,'String'));
    p.otsu.deconv_theta=str2double(get(handles.edit32,'String'));
    p.otsu.deconv_nsr=str2double(get(handles.edit33,'String'));
    
    p.ds.alpha=str2double(get(handles.edit21,'String'));
    p.ds.beta=str2double(get(handles.edit22,'String'));
    p.ds.gamma=str2double(get(handles.edit23,'String'));
    p.ds.epsilon=str2double(get(handles.edit24,'String'));
    p.ds.delta=str2double(get(handles.edit25,'String'));
    p.ds.sigmagradient=str2double(get(handles.edit26,'String'));
    p.ds.diffuse_iterations=str2double(get(handles.edit27,'String'));
    p.ds.kappa1=str2double(get(handles.edit28,'String'));
    p.ds.kappa2=str2double(get(handles.edit29,'String'));
    p.ds.gauss_filter_siz=str2double(get(handles.edit30,'String'));
    p.ds.gauss_filter_fit=str2double(get(handles.edit31,'String'));
    
    p.id.radius=str2double(get(handles.edit34,'String'));
    p.id.xy_length = io.p.id.radius/io.resolution_xy;
    p.id.z_length = io.p.id.radius/io.resolution_z;
    est_wlet = io.p.id.xy_length*0.26;
    
    p.id.wavelet_on = get(handles.checkbox4,'Value');
    if p.id.wavelet_on ==1
        p.id.wavelet_scale = est_wlet*3/4 : est_wlet*1/4 :est_wlet*5/4;  
    else
        A = str2double(get(handles.edit12,'String'));
        if isempty(find(A==','))==0
            B = strsplit(A,',');
            for bi=1:size(B,2)
                C(1,bi) = str2double(B{1,bi}); 
            end
            p.id.wavelet_scale_input=C;
        end
    end  
    
    
    p.otsu.otsu_on = get(handles.checkbox9,'Value');
    mtd = [];
    if get(handles.checkbox1,'Value')==1;mtd = [mtd 1];end
    if get(handles.checkbox2,'Value')==1;mtd = [mtd 2];end
    if get(handles.checkbox3,'Value')==1;mtd = [mtd 3];end
    if get(handles.checkbox8,'Value')==1;mtd = [mtd 4];end
    p.id.seg_method = mtd;
    
    % find p.mat in [function] folder

    if exist([d_fol 'p.mat'],'file')~=0
        save([d_fol 'p.mat'],'p','-append');
    end
    
end
 %}
delete(hObject);
end

% ------------------------------------------------
% --- Executes just before run1_parameters is made visible.
function run2_parameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to run1_parameters (see VARARGIN)

% Choose default command line output for run1_parameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes run1_parameters wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double
end

% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

%% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);
image_no= get(handles.popupmenu1,'Value');
time_no = 1;
t = 1;
%{
%% Default load first image information
d_fol = data_folder{1};
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
end
load(d_fol);
load([data_folder{image_no} 'sta.mat']);
time_no = 1; %str2num(get(handles.edit4,'String'));
time_no = max(min(max(io.t_mm),time_no),min(io.t_mm));
handles.time_no = time_no;


for mm = 1:size(p.id.seg_method,2)

    s_fol = [data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(time_no(1)) '.mat'];
    if ispc ==1
        s_fol(findstr(s_fol, '/'))='\';
    end
    if exist(s_fol,'file')~=0;load(s_fol,'xyzintsegdat');end
    if exist('xyzintsegdat_nororate','var')==1
        xyzintsegdat = xyzintsegdat_nororate;
    else
        xyzintsegdat_nororate = xyzintsegdat;
        save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'],'seg_result','-append');
    end
end
%}

% ----------- rotate ------------
%{
    if isfield(seg_result,'nucle_prop_nororate')==1
        xyzintsegdat = seg_result.xyzintsegdat_nororate;
    else
        seg_result.xyzintsegdat_nororate = xyzintsegdat;
        save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'seg_result','-append');
    end

    % delete nodueli from delete_list  [George]
    nucle_prop = delete_list(nucle_prop,p.nucle_delete_list);
    xyz_n = size(nucle_prop,1);

    % modify nuclei number in every dataset
    if size(seg_result.cf_center_xyzi,1) - xyz_n ~=0||size(xyzintsegdat,1) ~= xyz_n || p.modify_nuclei_list ==1
        cf_center_xyzi = zeros(xyz_n,10);xyzintsegdat_temp = zeros(xyz_n,size(xyzintsegdat,2));
        shape_class_temp = zeros(1,xyz_n);shape_class_abnormal_temp = zeros(1,xyz_n);
        shape_feature_temp = zeros(12,xyz_n);
        for kk=1:xyz_n
            nn = find(seg_result.cf_center_xyzi(:,1)==nucle_prop(kk,1));
            if isempty(nn)~=1
                cf_center_xyzi(kk,:) = seg_result.cf_center_xyzi(nn,:);
                xyzintsegdat_temp(kk,:) = xyzintsegdat(nn,:);
                shape_class_temp(1,kk) = shape_class(1,nn);
                shape_class_abnormal_temp(1,kk) = shape_class_abnormal(1,nn);
                shape_feature_temp(:,kk) = shape_feature(:,nn);
            end
        end
        xyzintsegdat = xyzintsegdat_temp;
        shape_class = shape_class_temp;
        shape_class_abnormal = shape_class_abnormal_temp;
        seg_result.cf_center_xyzi = cf_center_xyzi;
        shape_feature = shape_feature_temp;
        save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'seg_result','-append');
        save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'xyzintsegdat','-append');
        clear seg_result xyzintsegdat_temp cf_center_xyzi
    end
    height_level = get_height_level(nucle_prop(:,4));
    [nucle_prop,p] = rotate_fun(nucle_prop,[p.rotate_angle 0],p,[mean(nucle_prop(:,2:3)) 0],0);
    nucle_prop = update3D(nucle_prop,p);
    save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'nucle_prop','height_level','-append');
    var = whos('-file',[data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat']);
    for ii=1:size(var,1)
        if strcmp(var(ii).name, 'nucle_coordination')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'nucle_coordination');
            nucle_coordination = nucle_coordination_update(nucle_coordination,nucle_prop,height_level,p);
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'nucle_coordination','-append');
        end
        if strcmp(var(ii).name, 'xyzintsegdat')==1
            xyzintsegdat(:,1:3) = [nucle_prop(:,3) nucle_prop(:,2) nucle_prop(:,4)];
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_t' num2str(t) '.mat'],'xyzintsegdat','-append');
        end                    
    end

    var = whos('-file',[data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat']);
    for ii=1:size(var,1)
        if strcmp(var(ii).name, 'nucle_prop_time')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_prop_time');
            nucle_prop_time{t} = nucle_prop;
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_prop_time','-append');
        end
        if strcmp(var(ii).name, 'nucle_coordination_time')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_coordination_time');
            nucle_coordination_time{t} = nucle_coordination;
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'nucle_coordination_time','-append');
        end
        if strcmp(var(ii).name, 'xyzintsegdat_time')==1
            load([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'xyzintsegdat_time');
            xyzintsegdat_time{t} = xyzintsegdat;
            save([data_folder{i} 'stack' num2str(p.id.seg_method(1,m)) '_time.mat'],'xyzintsegdat_time','-append');
        end                   
    end
%}
% ----------- rotate ------------






% Update handles structure
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

%% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);
image_no= get(handles.popupmenu1,'Value');

%% Default load first image information
d_fol = data_folder{1};
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
end
load(d_fol);
%if exist('now_image','var')==1
%    image_no = now_image;
%end

res_xy = p.io.resolution_xy;
res_z = p.io.resolution_z;

for mm = 1:size(p.id.seg_method,2)
    for t = io.t_mm
    s_fol = [data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'];
    if ispc ==1
        s_fol(findstr(s_fol, '/'))='\';
    end
    rotate_angle_xy = str2num(get(handles.edit36,'String'));
    rotate_angle_xz = str2num(get(handles.edit37,'String'));
    rotate_angle_yz = str2num(get(handles.edit35,'String'));

    if exist(s_fol,'file')~=0;load(s_fol,'xyzintsegdat','xyzintsegdat_id');end
    if exist('xyzintsegdat','var')==1
        xyz_data = xyzintsegdat(:,1:3).*repmat([res_xy res_xy res_z],size(xyzintsegdat,1),1);
        nn = convhull(xyz_data(:,1:2));xy_center = [mean(xyz_data(nn,1:2)) mean(xyz_data(:,3))];
        xyz_data = xyz_data - repmat(xy_center,size(xyz_data,1),1);
        %[xyz_data,p] = rotate_fun(xyz_data,[rotate_angle_xy rotate_angle_z],p,[mean(xyz_data(:,1:2)) 0],0);
        xyz_data=trans4(xyz_data,[rotate_angle_xy,rotate_angle_xz,rotate_angle_yz],5);
        %xyz_data = xyz_data + xy_center;
        xyzintsegdat(:,1:3) = xyz_data.*repmat([1/res_xy 1/res_xy 1/res_z],size(xyzintsegdat,1),1);
        xyzintsegdat(:,3) = round(xyzintsegdat(:,3));xyzintsegdat(:,3) = xyzintsegdat(:,3) -min(xyzintsegdat(:,3))+1;
        save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'],'xyzintsegdat','-append');
        xyzintsegdat_time{t} = xyzintsegdat;
    end

    if exist(s_fol,'file')~=0;load(s_fol,'seg_result');end
    if exist('seg_result','var')==1
        if isempty(seg_result)~=1
            if size(xyzintsegdat_id,1)-size(seg_result.cf_center_xyzi,1)~=0
                cf_center_xyzi0 = seg_result.cf_center_xyzi;
                cf_center_xyzi1 = [];
                for ii = 1:size(xyzintsegdat_id,1)
                    nn = find(cf_center_xyzi0(:,1) == xyzintsegdat_id(ii,1));
                    if isempty(nn)~=1;cf_center_xyzi1 = [cf_center_xyzi1;[cf_center_xyzi0(nn,1) xyzintsegdat(ii,[2 1 3]) cf_center_xyzi0(nn,5:end)]];end
                end
                seg_result.cf_center_xyzi = cf_center_xyzi1;
            elseif xyzintsegdat_id==seg_result.cf_center_xyzi(:,1)
                cf_center_xyzi0 = seg_result.cf_center_xyzi;
                cf_center_xyzi1 = [];
                for ii = 1:size(xyzintsegdat_id,1)
                    nn = find(cf_center_xyzi0(:,1) == xyzintsegdat_id(ii,1));
                    if isempty(nn)~=1;cf_center_xyzi1 = [cf_center_xyzi1;[cf_center_xyzi0(nn,1) xyzintsegdat(ii,[2 1 3]) cf_center_xyzi0(nn,5:end)]];end
                end
                seg_result.cf_center_xyzi = cf_center_xyzi1;
            else
                seg_result.cf_center_xyzi(:,2:4) = [xyzintsegdat(:,2),xyzintsegdat(:,1),xyzintsegdat(:,3)];
            end
            save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'],'seg_result','-append');
            clear seg_result
        end
    end
    end
    save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_time.mat'],'xyzintsegdat_time','-append');
end

% Update handles structure
guidata(hObject, handles);
close(run2_parameters);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);

%% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);
image_no= get(handles.popupmenu1,'Value');
time_no = 1;
t = 1;

%% Default load first image information
d_fol = data_folder{1};
d_fol = [d_fol 'p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
end
load(d_fol);
load([data_folder{image_no} 'sta.mat']);

for mm = 1:size(p.id.seg_method,2)
    for t = io.t_mm
    s_fol = [data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'];
    if ispc ==1
        s_fol(findstr(s_fol, '/'))='\';
    end
    if exist(s_fol,'file')~=0
        load(s_fol,'xyzintsegdat_nororate','xyzintsegdat_nororate_id','seg_result');
    end

    if exist('xyzintsegdat_nororate','var')==1
        xyzintsegdat = xyzintsegdat_nororate;
        xyzintsegdat_id = xyzintsegdat_nororate_id;
        xyzintsegdat_time{t} = xyzintsegdat;
        xyzintsegdat_id_time{t} = xyzintsegdat_id;
        save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'],'xyzintsegdat','-append');
    end
    
    if exist('seg_result','var')==1
        if isempty(seg_result)~=1
            if size(xyzintsegdat_id,1)-size(seg_result.cf_center_xyzi,1)~=0
                cf_center_xyzi0 = seg_result.cf_center_xyzi;
                cf_center_xyzi1 = [];
                for ii = 1:size(xyzintsegdat_id,1)
                    nn = find(cf_center_xyzi0(:,1) == xyzintsegdat_id(ii,1));
                    if isempty(nn)~=1;cf_center_xyzi1 = [cf_center_xyzi1;[cf_center_xyzi0(nn,1) xyzintsegdat(ii,[2 1 3]) cf_center_xyzi0(nn,5:end)]];end
                end
                seg_result.cf_center_xyzi = cf_center_xyzi1;
            elseif xyzintsegdat_id==seg_result.cf_center_xyzi(:,1)
                cf_center_xyzi0 = seg_result.cf_center_xyzi;
                cf_center_xyzi1 = [];
                for ii = 1:size(xyzintsegdat_id,1)
                    nn = find(cf_center_xyzi0(:,1) == xyzintsegdat_id(ii,1));
                    if isempty(nn)~=1;cf_center_xyzi1 = [cf_center_xyzi1;[cf_center_xyzi0(nn,1) xyzintsegdat(ii,[2,1,3]) cf_center_xyzi0(nn,5:end)]];end
                end
                seg_result.cf_center_xyzi = cf_center_xyzi1;
            else
                seg_result.cf_center_xyzi(:,2:4) = [xyzintsegdat(:,2),xyzintsegdat(:,1),xyzintsegdat(:,3)];
            end
            save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_t' num2str(t) '.mat'],'seg_result','-append');
            clear seg_result
        end
    end
    
    end
    save([data_folder{image_no} 'stack' num2str(p.id.seg_method(mm)) '_time.mat'],'xyzintsegdat_time','-append');
end

% Update handles structure
guidata(hObject, handles);
close(run2_parameters);
end

function [prop2,p] = rotate_fun(prop,calib_thi,p,nuc_center,scale_opt)
p.DV_section_number = 36;
p.DV_sectionZ_number = 10;

n = size(prop,1); 
thi = zeros(n,6);
if scale_opt ==1
    prop(:,1) = (prop(:,1) - nuc_center(:,1))*p.resolution_xy;
    prop(:,2) = (prop(:,2) - nuc_center(:,2))*p.resolution_xy;
    prop(:,3) = (prop(:,3) - nuc_center(:,3))*p.resolution_z;
else
    prop(:,1) = prop(:,1) - nuc_center(:,1);
    prop(:,2) = prop(:,2) - nuc_center(:,2);
    prop(:,3) = prop(:,3) - nuc_center(:,3);
end


prop2=prop;

pmax=max(abs(prop(prop(:,3)==min(prop(:,3)),3)));
hmax=max(abs(prop(:,3)));
% -- calcualte angle for data
[thi(:,1), thi(:,2), r] = cart2sph(prop(:,1),prop(:,2),prop(:,3)+max(pmax-hmax,0));
for i=1:size(prop,1)
    % xy plane
    if prop(i,2)<0
      %thi(i,1) = sign(thi(i,1))*pi - thi(i,1);
    end
    if thi(i,1)<0
        thi(i,1) = 2*pi+thi(i,1);
    end
end


nmax = max(thi(:,2));nmin = min(thi(:,2));
for i=1:n
    thi(i,3) = min(max(ceil(thi(i,1)/(2*pi/p.DV_section_number)),1),p.DV_section_number);
    thi(i,4) = min(max(round((thi(i,2)-nmin)/((nmax-nmin)/p.DV_sectionZ_number)),1),p.DV_sectionZ_number);
    thi(i,5) = (thi(i,4)-1)*p.DV_sectionZ_number + thi(i,3);
    thi(i,6) = sqrt((prop(i,3)).^2 + (prop(i,1)).^2 + (prop(i,2)).^2);
end


for ni = 1:size(prop,1)
    thi(ni,1) = thi(ni,1) - calib_thi(1,1);
    if thi(ni,1)<0
        thi(ni,1) = thi(ni,1) +2*pi;
    elseif thi(ni,1)>2*pi
        thi(ni,1) = thi(ni,1) -2*pi;
    end   

    prop2(ni,1) = cos(thi(ni,1))*sqrt(prop(ni,1)^2+prop(ni,2)^2) + nuc_center(:,1);
    prop2(ni,2) = sin(thi(ni,1))*sqrt(prop(ni,1)^2+prop(ni,2)^2) + nuc_center(:,2);
   
end

%[prop2(:,5:7),prop2(:,1:3)] = xyz_ang(prop2(:,1:3),[0,0,0],p,0);

end
function [thi,A] = xyz_ang(A,nuc_center,p,scale_opt)

% -- check A and nuc_center dimensional
if size(A,2)>4
    A=A';
end
if exist('nuc_center','var')==1
    if size(nuc_center,2)~=size(A,2)
        nuc_center=nuc_center';
    end
end
n = size(A,1); 


% -- calcualte angle for data
if size(A,2)==3
    thi = zeros(n,3);
    if exist('nuc_center','var')~=1
        nuc_center = mean(A);
    end
    if scale_opt==1
        A(:,1) = (A(:,1) - nuc_center(:,1))*p.resolution_xy;
        A(:,2) = (A(:,2) - nuc_center(:,2))*p.resolution_xy;
        if exist('p','var')~=1
            A(:,3) = A(:,3) - nuc_center(:,3);
        else
            A(:,3) = (A(:,3) - nuc_center(:,3))*p.resolution_z;
        end
    else
        A(:,1) = A(:,1) - nuc_center(:,1);
        A(:,2) = A(:,2) - nuc_center(:,2);
        if exist('p','var')~=1
            A(:,3) = A(:,3) - nuc_center(:,3);
        else
            A(:,3) = A(:,3) - nuc_center(:,3);
        end
    end
    thi = zeros(size(A,1),3);
    pmax=max(abs(A(A(:,3)==min(A(:,3)),2)));
    hmax=max(abs(A(:,3)));
    [thi(:,1), thi(:,2), thi(:,3)] = cart2sph(A(:,1),A(:,2),A(:,3)+max(pmax-hmax,0));
    for i=1:size(A,1)
        % xy plane
        if A(i,1)<0
          %thi(i,1) = sign(thi(i,1))*pi - thi(i,1);
        end
        if thi(i,1)<0
            thi(i,1) = 2*pi+thi(i,1);
        end
    end

elseif size(A,2)==2
    thi = zeros(n,2);
    if exist('nuc_center','var')~=1
        nuc_center = mean(A);
    end
    if scale_opt==1
        A(:,1) = (A(:,1) - nuc_center(:,1))*p.resolution_xy;
        A(:,2) = (A(:,2) - nuc_center(:,2))*p.resolution_xy;
    else
        A(:,1) = A(:,1) - nuc_center(:,1);
        A(:,2) = A(:,2) - nuc_center(:,2);
    end

    for i=1:n
        % xy plane
        thi(i,1) = real(asin(A(i,2) ./ sqrt((A(i,1)).^2 + (A(i,2)).^2)));
        if A(i,1)<0
          thi(i,1) = sign(thi(i,1))*pi - thi(i,1);
        end
        if thi(i,1)<0
            thi(i,1) = 2*pi+thi(i,1);
        end

        % radius
        thi(i,2) = sqrt((A(i,1)).^2 + (A(i,2)).^2);
    end
end

end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double
end

% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
function xprime=trans4(x,delx,mod)
%
%function xprime=trans4(x,delx,mod)
%For dimensional transformation
%mod indicates the type of transformation
%  mod=1 for translation
%  mod=2 for scaling(enlarging or shrinking)
%  mod=3 for inversion delx=[-1 -1 -1]
%  mod=4 for shearing delx=[xa ya za]
%  mod=5 for rotation delx=[angx angy angz]
% written by D.S. Fon, Bime, NTU
%
[n,m]=size(x);
x=[x,ones(n,1)];
tt=eye(m+1);
switch mod
 case 1 %translation
    tt(m+1,:)=[delx 1];
    xx=x*tt;
 case {2,3} %enlarging & inversion
    tt(tt==1)=[delx 1];
    xx=x*tt;
 case 4  %shear
    if m<3
     tt(2,1)=delx(1);
     tt(1,2)=delx(2);
    else
      if size(delx,1)==1
          delx(2,:)=0;
      end
      tt(2:3,1)=delx(1:2,1);%[1 d g 0]' for x
      tt(1,2)=delx(1,2);    %[b 1 0 0]' for y
      tt(3,2)=delx(2,2);    %[b 1 h 0]' for y again
      tt(1:2,3)=delx(1:2,3);%[c f 1 0]' for z
    end
    xx=x*tt;
 case 5
     d2g=pi/180;
     theta=delx*d2g;
     if m<3
         t=theta(1);
         sint=sin(t);cost=cos(t);
         tt(1,1)=cost;tt(1,2)=sint;
         tt(2,1)=-sint;tt(2,2)=cost;
         xx=x*tt;
     else
         tt0=tt;
         if abs(theta(1))>0   % rotate with x-axis
             cost=cos(theta(1));sint=sin(theta(1));
             tt0(2,2:3)=[cost sint];
             tt0(3,2:3)=[-sint cost];
             x=x*tt0;
         end
         if abs(theta(2))>0   % rotate with y-axis
             cost=cos(theta(2));sint=sin(theta(2));
             tt0=tt;
             tt0(1,1:3)=[cost 0 -sint];
             tt0(3,1:3)=[sint 0 cost];
             x=x*tt0;
         end
         if abs(theta(3))>0  % rotate with z-axis
             cost=cos(theta(3));sint=sin(theta(3));
             tt0=tt;
             tt0(1,1:2)=[cost sint];
             tt0(2,1:2)=[-sint cost];
             x=x*tt0;
         end
         xx=x;
     end
 end
xprime=xx(:,1:m);
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double
end

% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
