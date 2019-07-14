function varargout = sc_viewer(varargin)
% SC_VIEWER MATLAB code for sc_viewer.fig
%      SC_VIEWER, by itself, creates a new SC_VIEWER or raises the existing
%      singleton*.
%
%      H = SC_VIEWER returns the handle to a new SC_VIEWER or the handle to
%      the existing singleton*.
%
%      SC_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SC_VIEWER.M with the given input arguments.
%
%      SC_VIEWER('Property','Value',...) creates a new SC_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sc_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sc_viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sc_viewer

% Last Modified by GUIDE v2.5 22-Jan-2018 15:10:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sc_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @sc_viewer_OutputFcn, ...
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


% --- Executes just before sc_viewer is made visible.
function sc_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sc_viewer (see VARARGIN)

global  sz  lung_msk  sc_msk

% Choose default command line output for sc_viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sc_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);

[ fn,pn ] = uigetfile( fullfile( 'C:\Users\Suki''s Lab\Desktop\DATA\lung_imaging\lung_structs\-960HU', '*.mat' ) ) ;
s = load( fullfile( pn,fn ) ) ; 
sz = s.lungs.sz ;
pntr = s.lungs.pntr ;
lung_msk = zeros( sz ) ;    lung_msk( pntr(:,1) ) = 1 ;
sc_msk   = zeros( sz ) ;    sc_msk( pntr( pntr(:,6)>0, 1 ) ) = 1 ;

set( handles.edit2, 'String', '1' )
set( handles.edit1, 'String', num2str( sz(3) ) )
set( handles.slider1, 'Min', 0, 'Max', sz(3)-1, 'Value', sz(3)-1 )
disp_slice( handles )


% --- Outputs from this function are returned to the command line.
function varargout = sc_viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_up.
function pushbutton_up_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sl = str2double( get( handles.edit2, 'String' ) ) ;
if sl >1
    set( handles.edit2, 'String', num2str( sl-1 ) )
end
disp_slice( handles )


% --- Executes on button press in pushbutton_down.
function pushbutton_down_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sz
sl = str2double( get( handles.edit2, 'String' ) ) ;
if sl < sz(3)
    set( handles.edit2, 'String', num2str( sl+1 ) )
end
disp_slice( handles )


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global sz
set( hObject, 'String', num2str( sz(3) ) )


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global sz
sl = str2double( get( hObject, 'String' ) ) ;
if sl <1
    set( hObject, 'String', '1' ) ;
    set( handles.slider1, 'Value', 1 ) ;
elseif sl >sz(3)
    set( hObject, 'String', num2str( sz(3) ) ) ;
    set( handles.slider1, 'Value', num2str( sz(3) ) ) ;
end
disp_slice( handles )


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function disp_slice( handles )
% this function plots the current slice
global lung_msk  sc_msk
sl = str2double( get( handles.edit2, 'String' ) ) ;
CC = bwconncomp( sc_msk(:,:,sl), 4 ) ;
L  = label2rgb( labelmatrix(CC), @parula, [ 0 0 0 ], 'shuffle' ) ;
axes( handles.axes1 ) ; imshow( L ) ;
hold on
[ B,~ ] = bwboundaries( lung_msk(:,:,sl) ) ;
for ii = 1:length(B)
    plot( B{ii}(:,2), B{ii}(:,1), 'y-' ) ;
end
hold off


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global sz
sl = sz(3) - round( get( hObject, 'Value' ) ) ;
set( handles.edit2, 'String', num2str( sl ) )
disp_slice( handles )


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
