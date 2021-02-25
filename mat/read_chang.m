filename = 'F:\Desktop\dianci\sample_data\20201212-20201221-room\result\20201212-20201221time-chang-room-rms.txt';
filename1 = 'F:\Desktop\dianci\sample_data\20201212-20201221-room\result\20201212time-chang-room1-thin.txt';
delimiterIn   = '	'; % 字符分隔符
headerlinesIn = 1;   % 文件头的行数

A = importdata(filename, delimiterIn, headerlinesIn);
data = A.data;


B = importdata(filename1, delimiterIn, headerlinesIn);
data1 = B.data;

figure(1)
hold on;
rgb_i = 1;
day = data(1,3);
rgb = ['r','g','b','c','y','k','m'];
[row_num, col_num] = size(data);
x = 1:row_num;
day_start = 1;

for i = 1:row_num-1
    if data(i,3) ~= day || i==row_num-1
        temp_x = x(day_start:i);
        size_temp_x = size(temp_x);
        y = [];
        for j = 1:size_temp_x(2)
            y = [y;data(temp_x(j),6)];
        end
        plot(temp_x, y, rgb(rgb_i)); 
        clear y;
        day_start = i;
        rgb_i = rgb_i +1;
        if rgb_i > length(rgb)
            rgb_i = 1;
        end
        day = data(i+1,3);
    end
    
end

figure(2)
plot(data1(:,8))