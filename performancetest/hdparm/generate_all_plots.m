% Octave GNU Plotting
%
% Copyright (c) 2012-2015 Matthias Schmid <ramsondon@gmail.com>
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

% generates all plots as eps for this directory

% make one plot for all files with different colors
function generate_all_plots(epsfilename)

	h2usb = load_data_log_csv('h2usb');
	h2bbenc = load_data_log_csv('h2bb-enc');
	
	h2usbMean = compute_mean(h2usb);
	h2bbencMean = compute_mean(h2bbenc);
	
	label{1} = 'Host Computer direct USB access';
	label{2} = 'Host Computer USB access via Proxy'; 

	hold on;
	grid on;
	title('hdparm performance comparison','fontname','times new roman','fontsize',20);
	xlabel('nr of test','fontname','times new roman','fontsize',20)
	ylabel('Timing buffered disk reads in MB/s ','fontname','times new roman','fontsize',20)
	plot(h2usb(:,1), h2usb(:,2), 'r');
	plot(h2bbenc(:,1), h2bbenc(:,2), 'b');
	legend(label, 'location','northeast');

	%print(gcf, '-depsc2', '-r300', epsfilename);
	print(gcf, '-dpng', epsfilename);
	hold off;
	
end % function

function R = load_data_log_csv(prefix)
		
	files = dir(sprintf('%s*.log.csv', prefix));
	R = [];	
	for i = 1:length(files)
		raw = dlmread(files(i).name, ';', 0, 0);
		x = raw(:,1);
		y = raw(:,4);
		R = [R,x];
		R = [R,y];
	end

end % function

% compute_mean(matrix)
%
% computes the mean of each row considering every even row
%
% @param matrix
% @return vector
function m = compute_mean(M)
	
	T = [];
	for i=2:2:size(M,2)
		T = [T,M(:,i)];		
	end	
	m = mean(T');
	
end % function

