% Finding h_values with corresponding q_min values w/o uncertainty 


data = readmatrix('High1v2.csv'); % This pulls all of the data from Excel

d = 0.0254; % 1 inch (metric) down into the aluminum block
T_x = data(1:855, 2); % Temp data from column 2
T_i = 128.756; % Initial Temp of the Aluminum block (C)
T_f = 20; % Final Temp of the Aluminum block (C)
t = data(1:855,6); % Time data from column 6
k = 237 %- 23.7 %11.85; % Thermal conductivity of Aluminum Block
alpha = 0.0000971 %+ 0.00000194 %0.000001746; % Thermal Diffusivity of Aluminum Block

figure(1)
plot(t,T_x)
% Add low Uncertainty bounds of above variables
d_low = 0.0254 - 0.0015875
T_x_low = data(1:810,2) - 2.2
T_i_low = 128.661 - 2.2
T_f_low = 20 - 2.2
t_low = data(1:810,6) - 0.2
alpha_low = alpha - 0.018
k_low = k - 0.05

% Calculate nominal h_values without uncertainty
N = length(T_x);
h_values_nom = 1:0.1:120
q_nom = zeros(N , 1);
h_nom = zeros(N , 1);

for i = 120:N
   L(i) = (T_x(i) - T_i)/(T_f - T_i);
   current_q_nom = inf % Starting with a large Number so we can find the smallest
   current_h_nom = NaN % We have not found what h should be, so this is a placeholder
   for h = h_values_nom;
      % R = (t(i) + h)
      R2 = erfc(d/(2*sqrt(alpha*t(i)))) ...
          - (exp((h*d)/k)+((h^2*alpha*t(i))/(k^2)))*...
          (erfc((d/(2*sqrt(alpha*t(i)))+((h*sqrt(alpha*t(i)))/k))));
      q = abs(L(i) - R2);
      if q < current_q_nom
          current_q_nom = q;
          current_h_nom = h;
      end
  end
  q_nom(i) = current_q_nom;
  h_nom(i) = current_h_nom;
end

disp(q_nom);
disp(h_nom);

figure(2)
j = histogram(h_nom(150:end),'FaceColor',[0.7 0.7 0.7],'EdgeColor','k')
xlabel('h (W/mK)', 'FontSize',10,'FontName','Arial')
ylabel('Frequency (Population)','FontSize',10,'FontName','Arial')
j.FaceColor = [0.9 0.9 0.9]
j.EdgeColor = 'k'
set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', 'FontSize', 10);
set(gcf, 'Color', 'w'); % Set figure background to white


figure(3)
plot(t,h_nom)

% ADD UNCERTAINTY
% Need a graph for every speed and every uncertuncertainty bounds
% Find the h_values with high bounds and low bounds of uncertainty

