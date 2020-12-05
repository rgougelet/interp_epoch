try
	fig = gcbf; % eegplot window should/will be open when this callback is called
	g = get(fig, 'UserData'); % get embedded eegplot data structure
	ax1 = findobj('tag', 'eegaxis', 'parent', fig); % get plot axis

	% capture right click location and identify corresponding channel
	tmppos = get(ax1, 'currentpoint');
	tmpelec = round(tmppos(1, 2) / g.spacing); % adjust for channel spacing
	tmpelec = min(max(double(tmpelec), 1), g.chans); % account for channels outside view
	tmpelec = length(g.eloc_file)-tmpelec+1; % invert

	% find nearest trials boundaries for epoched data only
	if g.trialstag ~= -1 
		lowlim = round(g.time*g.trialstag+1);
		alltrialtag = [0:g.trialstag:g.frames];
		I1 = find(alltrialtag < (tmppos(1)+lowlim));
		if ~isempty(I1) && I1(end) ~= length(alltrialtag)
			r = [max(alltrialtag(I1(end)), 1),... % left point account for if edge < 1
				alltrialtag(I1(end)+1)-1,... % right point, alltrialtag not really needed
				[1 1 1],... % rejections are color based, use this color
				false(1, g.chans)]; % preallocate every channel to false
			r(end, 5+tmpelec) = true; % mark channel as true
			if isempty(g.winrej)
				g.winrej(1, :) = r;
			else
				% if right clicking an already marked
				% single channel and single epoch, then remove
				sg_ch = all(g.winrej==r, 2);
				sum(sg_ch)
				if any(sg_ch)
					g.winrej(sg_ch, :) = [];
				else
					% if right clicking a whole marked epoch, remove whole mark
					all_ch = all(g.winrej==[r(1), r(2)-1, [1 1 .783], false(1, g.chans)], 2);
					all_ch = all_ch | all(g.winrej==[r(1), r(2), [1 1 .783], false(1, g.chans)], 2);
					if any(all_ch)
						g.winrej(all_ch, :) = [];
					end
					% add single channel and single epoch mark
					g.winrej(end+1, :) = r;
				end
			end
			set(fig, 'UserData', g);
			eegplot('drawp', 0);
		end
	end
catch me
	warning("Marking channel for interpolation within single epoch failed");
	disp( getReport(me, 'extended', 'hyperlinks', 'on' ) )
end




