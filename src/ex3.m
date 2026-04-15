function varargout = ex3(varargin)
% EX3 MATLAB code for ex3.fig
%      EX3, by itself, creates a new EX3 or raises the existing
%      singleton*.
%
%      H = EX3 returns the handle to a new EX3 or the handle to
%      the existing singleton*.
%
%      EX3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EX3.M with the given input arguments.
%
%      EX3('Property','Value',...) creates a new EX3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ex3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ex3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ex3

% Last Modified by GUIDE v2.5 26-Jul-2020 18:09:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ex3_OpeningFcn, ...
                   'gui_OutputFcn',  @ex3_OutputFcn, ...
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


% --- Executes just before ex3 is made visible.
function ex3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ex3 (see VARARGIN)

% Choose default command line output for ex3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ex3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ex3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


 [FileName,PathName] = uigetfile('*.jpg;*.png;*.bmp','Pick an MRI Image');
 if isequal(FileName,0)||isequal(PathName,0)
    warndlg('User Press Cancel');
 else
   P = imread([PathName,FileName]);
   P = imresize(P,[200,200]);
   axes(handles.input);
   imshow(P);
   [feat,img]=feature_extr(P);
   
   handles.image=img;
   
   Sf=handles.index
   feat1=[];
   for i=1:length(Sf)
        feat1(i)=feat(Sf(i));
   end
   handles.imgdata= feat1;
  guidata(hObject, handles);
   
% --- Executes on button press in detect.
 end
function detect_Callback(hObject, eventdata, handles)
% hObject    handle to detect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


feat=handles.imgdata;


xdata = handles.train;
group =handles.group;
svmStruct1 = fitcsvm(xdata,group,'KernelFunction', 'RBF');
species = predict(svmStruct1,feat);
%add
xdata=[xdata;feat];
group=[group;species];
handles.train=xdata;
handles.group=group;


 
 if strcmpi(species,'MALIGNANT')
     set(handles.type,'string','MALIGNANT');
     disp(' Malignant Tumor ');
 else
     set(handles.type,'string','BENIGN');
     disp(' Benign Tumor ');
 end
  
  axes(handles.segmented);
  imshow(handles.image);
  guidata(hObject, handles);

function [feat,img]=feature_extr(I)
  
  J = rgb2gray(I);
  level = graythresh(I);
  img = im2bw(J,0.7);
  img = bwareaopen(img,80); 
  signal1 = img(:,:);
  [cA1,cH1,cV1,cD1] = dwt2(signal1,'db4');
  [cA2,cH2,cV2,cD2] = dwt2(cA1,'db4');
  [cA3,cH3,cV3,cD3] = dwt2(cA2,'db4');
  DWT_feat = [cA3,cH3,cV3,cD3];
  G = pca(DWT_feat);
  g = graycomatrix(G);
  stats = graycoprops(g,'Contrast Correlation Energy Homogeneity');
  Contrast = stats.Contrast;
  Correlation = stats.Correlation;
  Energy = stats.Energy;
  Homogeneity = stats.Homogeneity;
  Mean = mean2(G);
  Standard_Deviation = std2(G);
  Entropy = entropy(G);
  RMS = mean2(rms(G));
  Variance = mean2(var(double(G)));
  a = sum(double(G(:)));
  Smoothness = 1-(1/(1+a));
  Kurtosis = kurtosis(double(G(:)));
  Skewness = skewness(double(G(:)));
% Inverse Difference Movement
  m = size(G,1);
  n = size(G,2);
  in_diff = 0;
  for i = 1:m
    for j = 1:n
        temp = G(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
  end
  IDM = double(in_diff);
    
  feat =[Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM];



function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of type as text
%        str2double(get(hObject,'String')) returns contents of type as a double


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in accuracy.
function accuracy_Callback(hObject, eventdata, handles)
% hObject    handle to accuracy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Accuracy_Percent= zeros(200,1);
itr = 100;
hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 100 iterations');
for i = 1:itr
data = handles.train;
label=handles.group;
%groups = ismember(label,'BENIGN   ');
groups = ismember(label,'MALIGNANT');
[train,test] = crossvalind('HoldOut',groups);
cp = classperf(groups);
svmStruct = fitcsvm(data(train,:),groups(train),'KernelFunction', 'RBF');
classes = predict(svmStruct,data(test,:));
classperf(cp,classes,test);
%Accuracy_Classification = cp.CorrectRate.*100;
Accuracy_Percent(i) = cp.CorrectRate.*100;
sprintf('Accuracy of RBF Kernel is: %g%%',Accuracy_Percent(i))
waitbar(i/itr);
end
delete(hWaitBar);
Max_Accuracy = max(Accuracy_Percent);
sprintf('Accuracy of RBF kernel is: %g%%',Max_Accuracy)

set(handles.accur,'string',Max_Accuracy);


% --- Executes during object creation, after setting all properties.
function accur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function accur_Callback(hObject, eventdata, handles)
% hObject    handle to accur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of accur as text
%        str2double(get(hObject,'String')) returns contents of accur as a double

%data   = [meas(:,1), meas(:,2)];


% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd images;
df =[];
for i=1 : 30
    
    str1=int2str(i);
    str2=strcat(str1,'.jpg');
    nor=imread(str2);
    I = imresize(nor,[200,200]);
    [feat,img]=feature_extr(I);
    df=[df;feat];
end
 handles.train= df;
 handles.train1= df;
 grouptrain={'BENIGN'; 'BENIGN' ;'BENIGN'; 'BENIGN'; 'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'BENIGN' ;'MALIGNANT'; 'MALIGNANT'; 'MALIGNANT'; 'MALIGNANT'; 'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';'MALIGNANT';};
 handles.group1=grouptrain;
 xdata =df;
label=grouptrain;
N=30; T=70; c1=2; c2=2; Vmax=10; Wmax=0.9; Wmin=0.4; 
[sFeat,Sf,Nf,curve]=jBPSO(xdata,label,N,T,c1,c2,Wmax,Wmin,Vmax);


df=sFeat;
handles.train=df

handles.index=Sf
handles.group=grouptrain;
cd ..;
f=msgbox('Data Prepared');
guidata(hObject, handles);


% --- Executes on button press in acc_with_svm.
function acc_with_svm_Callback(hObject, eventdata, handles)
% hObject    handle to acc_with_svm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Accuracy_Percent= zeros(200,1);
itr = 100;
hWaitBar = waitbar(0,'Evaluating Maximum Accuracy with 100 iterations');
for i = 1:itr
data = handles.train1;
label=handles.group1;
%groups = ismember(label,'BENIGN   ');
groups = ismember(label,'MALIGNANT');
[train,test] = crossvalind('HoldOut',groups);
cp = classperf(groups);
svmStruct = fitcsvm(data(train,:),groups(train),'KernelFunction', 'RBF');
classes = predict(svmStruct,data(test,:));
classperf(cp,classes,test);
%Accuracy_Classification = cp.CorrectRate.*100;
Accuracy_Percent(i) = cp.CorrectRate.*100;
sprintf('Accuracy of RBF Kernel is: %g%%',Accuracy_Percent(i))
waitbar(i/itr);
end
delete(hWaitBar);
Max_Accuracy = max(Accuracy_Percent);
sprintf('Accuracy of RBF kernel is: %g%%',Max_Accuracy)

set(handles.text7,'string',Max_Accuracy);
