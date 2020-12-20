
function plot_utils_circle(x,y,r,varargin)
color = [0,0,0];
line_style = '-';
for ii = 1:2:length(varargin)
    eval([varargin{ii} '= varargin{' num2str(ii+1) '};']);
end

hold on
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.001:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'k', 'lineWidth', 1, 'color', color, 'LineStyle', line_style);

hold off
end
