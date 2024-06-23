% Đọc tín hiệu giọng nói
[signal, fs] = audioread('xlths.wav');

% Hiển thị tín hiệu gốc
figure;
plot(signal);
xlabel('Thời gian (samples)');
ylabel('Biên độ');
title('Tín hiệu gốc');

% Chuẩn hóa tín hiệu
normalized_signal = signal / max(abs(signal));

% Hiển thị tín hiệu đã chuẩn hóa
figure;
plot(normalized_signal);
xlabel('Thời gian (samples)');
ylabel('Biên độ');
title('Tín hiệu đã chuẩn hóa');

% Lọc nhiễu với bộ lọc thông thấp
d = designfilt('lowpassfir', 'FilterOrder', 50, 'CutoffFrequency', 0.8, 'SampleRate', fs);
filtered_signal = filtfilt(d, normalized_signal);

% Đảm bảo hai tín hiệu có cùng kích thước
minLength = min(length(signal), length(filtered_signal));
signal = signal(1:minLength);
filtered_signal = filtered_signal(1:minLength);

% Hiển thị tín hiệu đã lọc
figure;
plot(filtered_signal);
xlabel('Thời gian (samples)');
ylabel('Biên độ');
title('Tín hiệu đã lọc nhiễu');

% Phát hiện hoạt động giọng nói (VAD)
threshold = 0.025;
padding = 5;
voice_activity = movmean(abs(filtered_signal) > threshold, padding*2+1) > 0.5;
voice_signal = filtered_signal(voice_activity);

% Hiển thị tín hiệu có giọng nói
figure;
plot(voice_signal);
xlabel('Thời gian (samples)');
ylabel('Biên độ');
title('Tín hiệu sau khi phát hiện giọng nói (VAD)');

% Áp dụng Pre-emphasis Filter
pre_emphasis = [1 -0.97];
signal_pre_emphasized = filter(pre_emphasis, 1, voice_signal);

% Hiển thị tín hiệu đã áp dụng pre-emphasis
figure;
plot(signal_pre_emphasized);
xlabel('Thời gian (samples)');
ylabel('Biên độ');
title('Tín hiệu đã áp dụng pre-emphasis');

% Lưu tín hiệu đã qua tiền xử lý
preprocessed_signal = signal_pre_emphasized;
% Trích xuất MFCC sử dụng Audio Toolbox
[coeffs, delta, deltaDelta, loc] = mfcc(preprocessed_signal, fs, 'LogEnergy', 'Replace');

% Tạo một bảng dữ liệu để lưu trữ các chỉ số MFCC 
mfccTable = array2table(coeffs);
mfccTable.Properties.VariableNames = compose('MFCC_%d', 1:size(coeffs, 2));
% Hiển thị bảng chỉ số MFCC
disp(mfccTable);

% Lưu MFCCs
mfccs = coeffs;
% Hiển thị MFCC
figure;
plot(mfccs');
xlabel('Frame Index');
ylabel('MFCC');
title('Mel Frequency Cepstral Coefficients (MFCC) after Preprocessing');

