function [y] = noisegen(x,snr)
    noise = randn(length(x),1);
    noise = noise - mean(noise);
    signal_power = sum(power(x,2))/length(x);
    noise_power  = signal_power/(10^(snr/10));
    noise = sqrt(noise_power)/std(noise) * noise;
    y = x + noise;
end