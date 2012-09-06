function plotboottimes()
   
    % data setup 
    N = [12.093, 14.414, 32.121, 17.409, 21.173, 29.116, 37.023, 17.135, 12.703];
    VFAT = [4.962, 5.748, 5.777, 5.729, 5.413, 5.743, 5.081, 5.475, 5.436, 5.678];
    % plot
    clf;
    hold on;
	grid on;
	axis([0.5,1.5,0,40]);	
	boxplot(N);
	
	tic('x');
	title('Write Speed Proxy 104 MB', 'fontname', 'times new roman', 'fontsize', 20);
	ylabel("Required time in s",'fontname', 'times new roman', 'fontsize', 20);
	print(['writespeed.png'],'-dpng','-color');
    hold off;

endfunction

