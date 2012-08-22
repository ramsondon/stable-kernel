function plotboottimes()
   
    % data setup 
    N = [34,25,60,42,62,39,93,30,63,117,25,83];
    NO_N = [37,42,38,42,97,41,41,37,28,42,40,30];

	suffix = '_enabled';
    % plot
    clf;
    hold on;
	grid on;
	axis([0.5,1.5,0,120]);	
	boxplot(N);
	
	tic('x');
	title('Boot Time', 'fontname', 'times new roman', 'fontsize', 20);
	ylabel("Boot time in s",'fontname', 'times new roman', 'fontsize', 20);
	print(['boottimes', suffix ,'.png'],'-dpng','-color');
    hold off;

endfunction

