%% Basal Ganglia - New Functional Architectures
% Final Model%
% Normal %
clear all
% Parameters Used%
% No of Channels %
N = 6;

% Synaptic Weights %
w_str_d1 = 1;
w_str_d2 = 1;
w_str_d2_gpe_out = -1;
w_str_d2_gpe_inn = -1;
w_str_d2_gpe_ta = -1;
w_str_snr = -1;
w_stn = 1;
w_stn_gpe_out = 0.8;
w_stn_gpe_inn = 0.8;
w_stn_gpe_ta = 0.8;
w_stn_snr = 0.9;

%% Varying weights %%
w_gpe_ta_str_d2 = -0.25;
w_gpe_ta_str_d1 = -0.25;
w_gpe_ta_gpe_ta = -0.75;
w_gpe_out_gpe_out = -0.75;
w_gpe_inn_gpe_inn = -0.75;
w_gpe_out_gpe_inn = -0.3;
w_gpe_out_gpe_ta = -0.75;
w_gpe_inn_gpe_ta = w_gpe_out_gpe_ta;
w_gpe_out_str_d2 = 0.5;
w_gpe_out_str_d1 = 0.5;
w_gpe_inn_str_d2 = 0.25;
w_gpe_inn_str_d1 = 0.25;

%%

w_gpe_out_stn = -0.8;
w_gpe_out_snr = -1;
w_gpe_inn_stn = -0.8;
w_gpe_inn_snr = -0.2;




% Thresholds %
t_str_d1 = 0.2;
t_str_d2 = 0.2;
t_stn = -0.25;
t_gpe_out = -0.2;
t_gpe_inn = -0.2;
t_gpe_ta = -0.2;
t_snr = -0.2;
% parameters %
h = 0;
s = 0;
p_h = zeros(9,1);
p_s = zeros(9,1);
R_w = zeros(9,1);
count = 1;

% Dopamine %
for da_d1 = 0:0.1:0.8
    da_d2 = da_d1;

    % Activation Vectors %
    % Set to zero due to quiesent state being zero %
    a_str_d1 = zeros(N,1);
    a_str_d2 = zeros(N,1);
    a_stn = zeros(N,1);
    a_gpe_out = zeros(N,1);
    a_gpe_inn = zeros(N,1);
    a_gpe_ta = zeros(N,1);
    a_snr = zeros(N,1);

    % Simulation Parameters %
    t = 5;                      % length of simulation
    dt = 0.01;                  % time-step
    sim = t / dt;

    % Output Arrays %

    o_str_d1 = zeros(N,sim);
    o_str_d2 = zeros(N,sim);
    o_stn = zeros(N,sim);
    o_gpe_out = zeros(N,sim);
    o_gpe_inn = zeros(N,sim);
    o_gpe_ta = zeros(N,sim);
    o_snr = zeros(N,sim);

    % Salience Input %
    ch1_onset = 1;
    ch2_onset = 2;

    for ch1_size = 0:0.1:1
        for ch2_size = 0:0.1:1

            transient_onset = 3;
            transient_off = 4;
            transient_size = 0;

            c = zeros(N,1);
            p = zeros(sim,N);

            % Artificial Neuron Parameters %
            k = 25;                     % gain
            m = 1;                      % slope
            d_c = exp(-k*dt);

            % Simulation %
            for steps = 2:sim

                %% calculate salience changes
                if steps * dt == ch1_onset
                    c(1) = ch1_size;
                end
                if steps * dt == ch2_onset
                    c(2) = ch2_size;
                end
                if steps * dt == transient_onset
                    c(1) = c(1) + transient_size;
                    %         c(2) = c(2) - transient_size;
                end
                if steps * dt == transient_off
                    c(1) = ch1_size;
                    %        c(2) = ch2_size;
                end
                p(steps,:) = c';

                % Striatum D1 %
                u_str_d1 = c .* w_str_d1 .* (1 + da_d1) + sum(o_gpe_ta(:,steps-1)) .* w_gpe_ta_str_d1 + (o_gpe_out(:,steps-1)) .* w_gpe_out_str_d1 + (o_gpe_inn(:,steps-1)) .* w_gpe_inn_str_d1;
                a_str_d1 = (a_str_d1 - u_str_d1) * d_c + u_str_d1;
                o_str_d1(:,steps) = ramp_output(a_str_d1,t_str_d1,m)';

                % Striatum D2 %
                u_str_d2 = c .* w_str_d2 .* (1 - da_d2)  + sum(o_gpe_ta(:,steps-1)) .* w_gpe_ta_str_d2 + (o_gpe_out(:,steps-1)) .* w_gpe_out_str_d2 + (o_gpe_inn(:,steps-1)) .* w_gpe_inn_str_d2;
                a_str_d2 = (a_str_d2 - u_str_d2) * d_c + u_str_d2;
                o_str_d2(:,steps) = ramp_output(a_str_d2,t_str_d2,m)';

                % STN %
                u_stn = c .* w_stn + o_gpe_out(:,steps-1) .* w_gpe_out_stn + o_gpe_inn(:,steps-1) .* w_gpe_inn_stn;
                a_stn = (a_stn - u_stn) * d_c + u_stn;
                o_stn(:,steps) = ramp_output(a_stn,t_stn,m)';

                % GPe Outer %
                u_gpe_out = sum(o_stn(:,steps)) .* w_stn_gpe_out + o_str_d2(:,steps) .* w_str_d2_gpe_out + o_gpe_out(:,steps-1) .* w_gpe_out_gpe_out;
                a_gpe_out = (a_gpe_out - u_gpe_out) * d_c + u_gpe_out;
                o_gpe_out(:,steps) = ramp_output(a_gpe_out,t_gpe_out,m)';

                % GPe-Inner %
                u_gpe_inn = sum(o_stn(:,steps)) .* w_stn_gpe_inn + o_str_d2(:,steps) .* w_str_d2_gpe_inn + o_gpe_out(:,steps) .* w_gpe_out_gpe_inn + o_gpe_inn(:,steps-1) .* w_gpe_inn_gpe_inn;
                a_gpe_inn = (a_gpe_inn - u_gpe_inn) * d_c + u_gpe_inn;
                o_gpe_inn(:,steps) = ramp_output(a_gpe_inn,t_gpe_inn,m)';

                % GPe-TA %
                u_gpe_ta = sum(o_stn(:,steps)) .* w_stn_gpe_ta + o_str_d2(:,steps) .* w_str_d2_gpe_ta + o_gpe_out(:,steps) .* w_gpe_out_gpe_ta + o_gpe_inn(:,steps) .* w_gpe_inn_gpe_ta + o_gpe_ta(:,steps-1) .* w_gpe_ta_gpe_ta;
                a_gpe_ta = (a_gpe_ta - u_gpe_ta) * d_c + u_gpe_ta;
                o_gpe_ta(:,steps) = ramp_output(a_gpe_ta,t_gpe_ta,m)';

                % GPi/SNr % % Normal %
                u_snr = sum(o_stn(:,steps)) .* w_stn_snr + o_str_d1(:,steps) .* w_str_snr + (o_gpe_out(:,steps) .* w_gpe_out_snr) + (o_gpe_inn(:,steps) .* w_gpe_inn_snr);
                a_snr = (a_snr - u_snr) * d_c + u_snr;
                o_snr(:,steps) = ramp_output(a_snr,t_snr,m)';

            end

            % Checking output with conditions of selectivity %
            i = 100;
            j = 200;
            k = [0 0 0 0 0 0];
            teta = 0;
            dist = 0.5 * o_snr(3,75);
            for i = 100:200
                if o_snr(1,i) > teta & o_snr(1,i+100) > teta & o_snr(2,i+100) > teta
                    k(1) = k(1) + 1;
                else if (o_snr(1,i) <= teta & o_snr(1,i+100) <= teta & o_snr(2,i+100) > teta & o_snr(2,i+100) > dist) | (o_snr(1,i) > teta & o_snr(1,i+100) > teta & o_snr(2,i+100) <= teta & o_snr(1,i+100) > dist)
                        k(2) = k(2) + 1;
                    else if o_snr(1,i) <= teta & o_snr(1,i+100) > teta & o_snr(2,i+100) <= teta & o_snr(1,i+100) > dist
                            k(3) = k(3) + 1;
                        else if o_snr(1,i) <= teta & o_snr(1,i+100) > teta & o_snr(2,i+100) > teta
                                k(4) = k(4) + 1;
                            else if o_snr(1,i) <= teta & o_snr(1,i+100) <= teta & o_snr(2,i+100) <= teta
                                    k(5) = k(5) + 1;
                                else if (o_snr(1,i) <= teta & o_snr(1,i+100) <= teta & o_snr(2,i+100) > teta & o_snr(2,i+100) <= dist) | (o_snr(1,i) > teta & o_snr(1,i+100) > teta & o_snr(2,i+100) <= teta & o_snr(1,i+100) <= dist) | (o_snr(1,i) <= teta & o_snr(1,i+100) > teta & o_snr(2,i+100) <= teta & o_snr(1,i+100) <= dist)
                                        k(6) = k(6) + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
            q = max(k);
            R_w(count) = (1 + da_d1)/(1 - da_d2);  % Dopamine ratio %
            h = h + hardness(ch1_size,ch2_size,q,k); % Template matching %
            s = s + softness(ch1_size,ch2_size,q,k);
            p_h(count) = (100 * h)/ 121;  % Calculating H (no of harnesss match) and S( number of sofness match)% %
            p_s(count) = (100 * s)/ 121;
            figure(1)
            axis([-0.1 1.1 -0.1 1.1])
            title({['Final Model'];['DA = ',num2str(da_d1)]});
            xlabel({['Channel 1 Salience']});
            ylabel({['Channel 2 Salience']});
            % plotting selection template %
            if k(1) == q % No selecion %
                plot(ch1_size,ch2_size,'ko','MarkerFaceColor','k','MarkerSize',4);
                hold on
            else if k(2) == q % Single channel selection %
                    plot(ch1_size,ch2_size,'ko','Markersize',8);
                    hold on
                else if k(3) == q % Switching %
                        plot(ch1_size,ch2_size,'ks','MarkerSize',8);
                        hold on
                    else if k(4) == q % Interference %
                            plot(ch1_size,ch2_size,'k^','MarkerFaceColor','k','MarkerSize',7);
                            hold on
                        else if k(5) == q % Dual channel selection %
                                plot(ch1_size,ch2_size,'ko','MarkerFaceColor','k','MarkerSize',8);
                                hold on
                            else if k(6) == q % Distortion %
                                    plot(ch1_size,ch2_size,'kv','MarkerSize',5);
                                    hold on
                                end
                            end
                        end
                    end
                end
            end
            slowplot(o_snr,p,dist);% Genertaing channel output plots %
            %pause(0.25);          % Slow down if necessary %
        end
    end
    fprintf('\nR_w = %2.2f\t',R_w(count));
    fprintf('DA = %2.2f\n',da_d1);
    fprintf('H = %2.0f   P(H) = %2.3f\n',h,p_h(count)); % Printing H and S values %
    fprintf('S = %2.0f   P(S) = %2.3f\n',s,p_s(count));
    h = 0;
    s = 0;
    count = count + 1;
    figure(1)
    clf
end
parameters(R_w,p_h,p_s) % Generating spline fits and Max P_h and Max P_s %





