function main_acq()
global frame_id;
global iq_acq_time;
global iq_spec_delt_time;
global spectrum_Execute_time;
global spctrum_acq_period;
global iq_span_count;
global iq_span;
global flag;
global save_path;
save_path = 'F:\Desktop\dianci\sample_data\';
flag=0;
frame_id = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 测量设置
task_period = 60*15;  %单位秒  每次采集时间差
task_execut_time = 1; %总测量数
task_start_delay = 5;  %启动延迟  给windows窗体提供加载时间

iq_span = [825e6,835e6; 870e6,880e6; 885e6,890e6; 890e6,909e6; 909e6,915e6;...
    930e6,935e6; 935e6,954e6; 954e6,960e6; 1.71e9,1.735e9; 1.735e9,1.755e9; 1.755e9,1.765e9;...
    1.765e9,1.78e9; 1.805e9,1.83e9; 1.83e9,1.85e9; 1.84e9,1.86e9; 1.86e9,1.88e9; 1.885e9,1.92e9; ...
    1.92e9,1.94e9; 1.94e9,1.965e9; 2.01e9,2.025e9; 2.11e9,2.13e9; 2.13e9,2.155e9; 2.3e9,2.32e9; 2.32e9,2.345e9;...
    2.345e9,2.37e9; 2.37e9,2.39e9; 2.402e9,2.442e9; 2.442e9,2.482e9; 2.555e9,2.575e9; 2.575e9,2.605e9; 2.605e9,2.635e9; 2.635e9,2.655e9;];
iq_span_count = size(iq_span,1);  %单位次  总共采集多少个波段 
iq_acq_time = 10; %单位ms    iq数据单次测量时间长度

spctrum_acq_period = 60;   %单位秒      %count 计数50次大约20s   
spectrum_Execute_time = 1;  %单位次    spectrum执行多少次
iq_spec_delt_time = 5;   %sgram测量完成后 等待多少s执行开始spec测量任务

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init();
delete(timerfind)   % 删除现有的定时器，重新创建一个定时器
task_timer = timer('Name','task_timer','TimerFcn',@task_TimerFcn,'StartDelay',task_start_delay,'Period',task_period,'ExecutionMode','fixedRate','TasksToExecute',task_execut_time);
%sgram_timer = timer('Name','sgram_timer','TimerFcn',@sgr_TimerFcn,'StartDelay',sgram_start_delay,'Period',sgram_acq_period,'ExecutionMode','fixedRate','TasksToExecute',sgram_span_count);
%sgram_timer = timer('Name','sgram_timer','TimerFcn',@sgr_TimerFcn,'StartDelay',sgram_start_delay,'ExecutionMode','singleShot');  %启动定时器 
disp(strrep(datestr(now),':','_'));
start(task_timer);
%startat(task_timer,'22:49:55');

while 1
    if flag==1
        task_Fcn();
        flag=0;
    end
    
end
end

function task_TimerFcn(obj,eventdata)
global flag;
flag=1;
end

function task_Fcn()
global span_i;
global iq_span_count;
global iq_spec_delt_time;
global spectrum_Execute_time;
global spctrum_acq_period;
global spec_frame_id;
global iq_frame_id;
global frame_id;
iq_frame_id = 1;
spec_frame_id = 1;
span_i = 1;  
frame_id = frame_id+1;
disp('//////////////////////////////////////////////////////////////////////////////////////////////');
disp(['///////////////////////////////////////第',num2str(frame_id),'次测量启动//////////////////////////////////////////']);
disp('//////////////////////////////////////////////////////////////////////////////////////////////');
for i=1:iq_span_count
    iq_Fcn();   %执行sgram测量
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 启动spec测量定时器
disp('//////////////////////////////////启动spectrum测量//////////////////////////////////');
spectrum_Timer = timer('Name','spectrum_timer','TimerFcn',@spec_TimerFcn,'StartDelay',iq_spec_delt_time,'Period',spctrum_acq_period,'ExecutionMode','fixedRate','TasksToExecute',spectrum_Execute_time);
%spectrum_Timer = timer('Name','spectrum_timer','TimerFcn',@spec_TimerFcn,'StartDelay',sgram_spec_delt_time,'ExecutionMode','singleShot');  %启动定时器 
start(spectrum_Timer);

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
global span_i;
global iq_span;
global iq_acq_time;
if strcmp(mode,'spectrum')
    %%%%%%%%%%%%%%%%%%%%%%%%%spectrum configure   %当span大于40mhz 工作在swept模式下
    spec_startFrequency = 80e6;
    spec_stopFrequency = 3e9;
    spe_rbw = 10e3;
    func_count = 50;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(myRSA, 'abort');
    fprintf(myRSA,'SENSE:SPECTRUM:CLEAR:RESULTS');  %清空当前波形数据
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SPECtrum 参数配置
    fprintf(myRSA,'SENSE:SPECTRUM:POINTS:COUNT P64001');   %trace point采集的点数
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
    
elseif strcmp(mode,'IQ')
    %%%%%%%%%%%%%%%%%%%%%%%%%sgram  configure
    iq_startFrequency = iq_span(span_i,1);
    iq_stopFrequency = iq_span(span_i,2);
    
    span_i = span_i+1;
    IQ_rbw = 10e3;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(myRSA, 'system:preset');   %清空历史记录
    fprintf(myRSA,'*RST;*CLS');
    fprintf(myRSA, 'abort');
    % Wait till the instrument completes making the measurement
    operationComplete = query(myRSA,'*OPC?');
    while ~isequal(str2double(operationComplete),1)
        operationComplete = query(myRSA,'*OPC?');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  参数设置
    fprintf(myRSA,['SENSE:SPECTRUM:FREQUENCY:START ',num2str(iq_startFrequency),'HZ']);
    fprintf(myRSA,['SENSE:SPECTRUM:FREQUENCY:STOP ',num2str(iq_stopFrequency),'HZ']);
    fprintf(myRSA,'SENSE:SPECTRUM:BANDWIDTH:RESOLUTION:AUTO OFF'); %手动设置rbw
    fprintf(myRSA,['SENSE:SPECTRUM:BANDWIDTH:RESOLUTION ',num2str(IQ_rbw),'HZ']);
    fprintf(myRSA,'TRACE:SPECTRUM:DETECTION POSitive');    % POSitive --  +peak
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  acq设置
    fprintf(myRSA,'SENSE:ACQUISITION:MODE LENGth');   %采样模式  
    
    fprintf(myRSA,['SENSE:ACQUISITION:SEConds ', num2str(iq_acq_time),'ms']);
    fprintf(myRSA,['SENSE:ACQUISITION:BANDWIDTH ', num2str(iq_stopFrequency - iq_startFrequency), 'HZ']);   %采样带宽
    fprintf(myRSA,'SENSE:ACQUISITION:BANDWIDTH 40MHz');   %采样带宽 
    %%%%%%%%%%%%%%矫正
    fprintf(myRSA,'INPUT:CORRECTION:EXTERNAL:TYPE DATA');  %TRACe  sgram进行DATA矫正
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
function spec_TimerFcn(obj,eventdata)
global frame_id;
global myRSA;
global spec_frame_id;
global save_path;

disp(['%%%%%%%%%%%%%%%%%%%%%%%%%开始第',num2str(spec_frame_id),'次spectrum测量%%%%%%%%%%%%%%%%%%%%%%%%%%%%              task_count:第',num2str(frame_id),'次']);
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
file_name = ['  "',save_path,num2str(frame_id),'-',num2str(spec_frame_id),';SPECTRUM;',time, '"'];
%fprintf(myRSA, ['MMEMORY:STORE:IQ:CSV',file_name]);    %保存IQ数据
fprintf(myRSA, ['MMEMORY:STORE:RESULTS',file_name]);    %保存波形数据
spec_frame_id = spec_frame_id + 1;
% if spec_frame_id > spectrum_Execute_time
%     spec_frame_id = 1;
% end
disp('Saving file...');
operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end
disp(['SPECTURM SAVE Done , filename:',file_name]);
t2=clock;
disp(['本次SPECTRUM测量及保存时间',num2str(etime(t2,t1)),'S']);
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sgram_timer定时器回调函数
function iq_Fcn()
global myRSA;
global span_i;
global iq_frame_id;
global frame_id;
global save_path;
global iq_span;
t1=clock;
disp(['%%%%%%%%%%%%%%%%%%%%%%%%%开始第',num2str(iq_frame_id),'次IQ测量%%%%%%%%%%%%%%%%%%%%%%%%%%%%              task_count:第',num2str(frame_id),'次']);
disp(['%%%%%%%%%%%%%%%%%%%%%%%%% START IQ DATA ACQ ,  time now:',strrep(datestr(now),':','_'),'  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
configure('IQ');
%%%%%%%%%%%%%%%%%%%%%%开始测量
fprintf(myRSA,'initiate:continuous off');
fprintf(myRSA,'initiate:immediate');
disp(['Making IQ measurement...          time now:',strrep(datestr(now),':','_')]);

operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end

time = strrep(datestr(now),':','_');   %csv文件名不能有：  选择替换为_
disp(['SGRAM ACQ Done,   time:',time]);
%file_name = ['  "',save_path,num2str(frame_id),'-',num2str(iq_frame_id),';SGRAM;',num2str(iq_span(span_i-1,:)),';',time, '"'];

file_name = ['  "',save_path,num2str(frame_id),'-',num2str(iq_frame_id),';SGRAM;',strrep(num2str(iq_span(span_i-1,:)./1000000), '  ', '-'),'MHZ;',time, '"'];
disp('Saving file...');

%fprintf(myRSA, ['MMEMORY:STORE:IQ:CSV',file_name]);
fprintf(myRSA, ['MMEMORY:STORE:IQ:MAT',file_name]);
iq_frame_id = iq_frame_id + 1;
operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end
disp(['IQ SAVE Done , filename:',file_name]);
t2=clock;
disp(['本次IQ保存时间',num2str(etime(t2,t1)),'S']);

end

