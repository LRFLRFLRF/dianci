function acq_onroad()
global frame_id;
global csv_path;
global pic_path;
save_path = 'F:\Desktop\dianci\sample_data\spectrum_test';
frame_id = 1;

if ~exist([save_path,'\spectrum_pic'],'dir')==0
   mkdir([save_path,'\spectrum_pic']);
end

if ~exist([save_path,'\spectrum_csv'],'dir')==0
   mkdir([save_path,'\spectrum_csv']);
end

csv_path = [save_path,'\spectrum_csv\'];
pic_path = [save_path,'\spectrum_pic\'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init();

while 1
    spec_TimerFcn();
    pause(0);
end
end

function init()
global myRSA;
% Create VISA connection
% Change VISA Address to that of your instrument
delete(instrfind);
visaAddress = 'GPIB8::1::INSTR';
myRSA = visa('tek', visaAddress);
myRSA.Timeout = 1000; % set timeout to 15 seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open the connection to the RSA
fopen(myRSA);
% Ask for instrument ID
ID=query(myRSA,'*idn?')
% preset, clear buffer, and stop acquisition
fprintf(myRSA, 'system:preset');
% Reset the instrument to a known state
fprintf(myRSA,'*RST;*CLS');
fprintf(myRSA, 'abort');

end

function configure(mode)
global myRSA;

if strcmp(mode,'spectrum')
    %%%%%%%%%%%%%%%%%%%%%%%%%spectrum configure   %当span大于40mhz 工作在swept模式下
    spec_startFrequency = 80e6;
    spec_stopFrequency = 3e9;
    spe_rbw = 10e3;
    func_count = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(myRSA, 'abort');
    fprintf(myRSA,'SENSE:SPECTRUM:CLEAR:RESULTS');  %清空当前波形数据
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SPECtrum 参数配置
    fprintf(myRSA,'SENSE:SPECTRUM:POINTS:COUNT P32001');   %trace point采集的点数 16001   64001  32001
    fprintf(myRSA,['SENSE:SPECTRUM:FREQUENCY:START ',num2str(spec_startFrequency),'HZ']);
    fprintf(myRSA,['SENSE:SPECTRUM:FREQUENCY:STOP ',num2str(spec_stopFrequency),'HZ']);
    fprintf(myRSA,'SENSE:SPECTRUM:BANDWIDTH:RESOLUTION:AUTO OFF'); %使能手动设置rbw
    fprintf(myRSA,['SENSE:SPECTRUM:BANDWIDTH:RESOLUTION ',num2str(spe_rbw),'HZ']);  %设置rbw
    
    %%%%%%%%%%%%%trace1
    fprintf(myRSA,'TRACE1:SPECTRUM:DETECTION POSitive');  %detection   方法  +peak
    fprintf(myRSA,'TRACE1:SPECTRUM:FUNCTION AVERage');   %function   方法  AVERage
    fprintf(myRSA,'TRACE1:SPECTRUM:COUNT:ENABLE ON');   %打开function计数功能
    fprintf(myRSA,['TRACE1:SPECTRUM:COUNT ',num2str(func_count)]);   %设置function计数功能值
    %%%%%%%%%%%%%trace2
    fprintf(myRSA,'TRACE2:SPECTRUM ON');
    fprintf(myRSA,'TRACE2:SPECTRUM:DETECTION POSitive');  %detection 方法  +peak
    fprintf(myRSA,'TRACE2:SPECTRUM:FUNCTION MAXHold');   %function 方法  maxhold
    fprintf(myRSA,'TRACE2:SPECTRUM:COUNT:ENABLE ON');   %打开function计数功能
    fprintf(myRSA,['TRACE2:SPECTRUM:COUNT ',num2str(func_count)]);   %设置function计数功能值
    %%%%%%%%%%%%%%矫正
    fprintf(myRSA,'INPUT:CORRECTION:EXTERNAL:TYPE TRACe');  %DATA  spec进行trace矫正
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 统一配置
fprintf(myRSA,'MMEMORY:STORE:IQ:SELECT:DATA IQ');  %SPECtra是DPX  ALL是所有
fprintf(myRSA,'MMEMory:STORe:IQ:SELEct:FRAMes HISTory'); 
%%%%%%%%%%%%%% 通用设置
fprintf(myRSA,'SENSE:POWER:UNITS DBUV_M');   %DBM    DBV   DBUV_M 
%fprintf(myRSA,'DISPlay:GENeral:MEASview:NEW SPECtrum');
fprintf(myRSA,'INPut:CORRection:EXTernal:EDIT1:INTerpolation LINear');
fprintf(myRSA,'INPut:CORRECTION:EXTERNAL:EDIT1:STATE ON');  %使能loss table


operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spectrum_timer定时器回调函数
function spec_TimerFcn()
global frame_id;
global myRSA;
global csv_path;
global pic_path;

disp(['%%%%%%%%%%%%%%%%%%%%%%%%%开始第',num2str(frame_id),'次spectrum测量%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
t1=clock;
configure('spectrum');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(myRSA,'DISPLAY:GENERAL:MEASVIEW:SELECT SPECtrum');  %选择SPECtrum窗口
disp(['Making spectrum measurement...          time now:',strrep(datestr(now),':','_')]); 
fprintf(myRSA,'initiate:continuous off');
fprintf(myRSA,'initiate:immediate');
% Wait till the instrument completes making the measurement
operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end

time = strrep(datestr(now),':','_');   %csv文件名不能有：  选择替换为_
disp(['SPECTURM ACQ Done,   time:',time]);

%%%%保存csv文件
csv_file_name = ['  "',csv_path,num2str(frame_id),';SPECTRUM;',time, '"'];
fprintf(myRSA, ['MMEMORY:STORE:RESULTS',csv_file_name]);    %保存波形数据
%%%保存pic
pic_file_name = ['  "',pic_path,num2str(frame_id),';SPECTRUM;',time, '.jpg"'];
fprintf(myRSA, ['MMEMory:STORe:SCReen',pic_file_name]);    %保存波形图片
frame_id = frame_id + 1;

disp('Saving file...');
operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end
disp(['SPECTURM SAVE Done , filename:',csv_file_name]);
t2=clock;
disp(['本次SPECTRUM测量及保存时间',num2str(etime(t2,t1)),'S']);
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end