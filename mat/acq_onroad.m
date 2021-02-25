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
    %%%%%%%%%%%%%%%%%%%%%%%%%spectrum configure   %��span����40mhz ������sweptģʽ��
    spec_startFrequency = 80e6;
    spec_stopFrequency = 3e9;
    spe_rbw = 10e3;
    func_count = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(myRSA, 'abort');
    fprintf(myRSA,'SENSE:SPECTRUM:CLEAR:RESULTS');  %��յ�ǰ��������
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SPECtrum ��������
    fprintf(myRSA,'SENSE:SPECTRUM:POINTS:COUNT P32001');   %trace point�ɼ��ĵ��� 16001   64001  32001
    fprintf(myRSA,['SENSE:SPECTRUM:FREQUENCY:START ',num2str(spec_startFrequency),'HZ']);
    fprintf(myRSA,['SENSE:SPECTRUM:FREQUENCY:STOP ',num2str(spec_stopFrequency),'HZ']);
    fprintf(myRSA,'SENSE:SPECTRUM:BANDWIDTH:RESOLUTION:AUTO OFF'); %ʹ���ֶ�����rbw
    fprintf(myRSA,['SENSE:SPECTRUM:BANDWIDTH:RESOLUTION ',num2str(spe_rbw),'HZ']);  %����rbw
    
    %%%%%%%%%%%%%trace1
    fprintf(myRSA,'TRACE1:SPECTRUM:DETECTION POSitive');  %detection   ����  +peak
    fprintf(myRSA,'TRACE1:SPECTRUM:FUNCTION AVERage');   %function   ����  AVERage
    fprintf(myRSA,'TRACE1:SPECTRUM:COUNT:ENABLE ON');   %��function��������
    fprintf(myRSA,['TRACE1:SPECTRUM:COUNT ',num2str(func_count)]);   %����function��������ֵ
    %%%%%%%%%%%%%trace2
    fprintf(myRSA,'TRACE2:SPECTRUM ON');
    fprintf(myRSA,'TRACE2:SPECTRUM:DETECTION POSitive');  %detection ����  +peak
    fprintf(myRSA,'TRACE2:SPECTRUM:FUNCTION MAXHold');   %function ����  maxhold
    fprintf(myRSA,'TRACE2:SPECTRUM:COUNT:ENABLE ON');   %��function��������
    fprintf(myRSA,['TRACE2:SPECTRUM:COUNT ',num2str(func_count)]);   %����function��������ֵ
    %%%%%%%%%%%%%%����
    fprintf(myRSA,'INPUT:CORRECTION:EXTERNAL:TYPE TRACe');  %DATA  spec����trace����
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ͳһ����
fprintf(myRSA,'MMEMORY:STORE:IQ:SELECT:DATA IQ');  %SPECtra��DPX  ALL������
fprintf(myRSA,'MMEMory:STORe:IQ:SELEct:FRAMes HISTory'); 
%%%%%%%%%%%%%% ͨ������
fprintf(myRSA,'SENSE:POWER:UNITS DBUV_M');   %DBM    DBV   DBUV_M 
%fprintf(myRSA,'DISPlay:GENeral:MEASview:NEW SPECtrum');
fprintf(myRSA,'INPut:CORRection:EXTernal:EDIT1:INTerpolation LINear');
fprintf(myRSA,'INPut:CORRECTION:EXTERNAL:EDIT1:STATE ON');  %ʹ��loss table


operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spectrum_timer��ʱ���ص�����
function spec_TimerFcn()
global frame_id;
global myRSA;
global csv_path;
global pic_path;

disp(['%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ��',num2str(frame_id),'��spectrum����%%%%%%%%%%%%%%%%%%%%%%%%%%%%']);
t1=clock;
configure('spectrum');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(myRSA,'DISPLAY:GENERAL:MEASVIEW:SELECT SPECtrum');  %ѡ��SPECtrum����
disp(['Making spectrum measurement...          time now:',strrep(datestr(now),':','_')]); 
fprintf(myRSA,'initiate:continuous off');
fprintf(myRSA,'initiate:immediate');
% Wait till the instrument completes making the measurement
operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end

time = strrep(datestr(now),':','_');   %csv�ļ��������У�  ѡ���滻Ϊ_
disp(['SPECTURM ACQ Done,   time:',time]);

%%%%����csv�ļ�
csv_file_name = ['  "',csv_path,num2str(frame_id),';SPECTRUM;',time, '"'];
fprintf(myRSA, ['MMEMORY:STORE:RESULTS',csv_file_name]);    %���沨������
%%%����pic
pic_file_name = ['  "',pic_path,num2str(frame_id),';SPECTRUM;',time, '.jpg"'];
fprintf(myRSA, ['MMEMory:STORe:SCReen',pic_file_name]);    %���沨��ͼƬ
frame_id = frame_id + 1;

disp('Saving file...');
operationComplete = query(myRSA,'*OPC?');
while ~isequal(str2double(operationComplete),1)
    operationComplete = query(myRSA,'*OPC?');
end
disp(['SPECTURM SAVE Done , filename:',csv_file_name]);
t2=clock;
disp(['����SPECTRUM����������ʱ��',num2str(etime(t2,t1)),'S']);
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end