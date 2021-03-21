function EEG = pop_mark(EEG)
	if ~isfield(EEG.etc,'wininterp') || isempty(EEG.etc.wininterp)
		wininterp = []; 
	else
		wininterp = EEG.etc.wininterp;
	end

	% this plugin integrates with native functionality to mark whole epochs
	if ~isempty(EEG.reject.rejmanual)
		rej_trial_inds = find(EEG.reject.rejmanual);
		% convert rejmanual into winrej format
		strtstp = [0 EEG.pnts-1]+(rej_trial_inds-1)'*EEG.pnts;
		strtstp(strtstp==0) = 1;
		rej_wininterp = [strtstp,...
									repmat([1 1 .783],...
									length(rej_trial_inds), 1),...
									zeros(length(rej_trial_inds),...
									EEG.nbchan)];
		if isempty(wininterp)
			wininterp = rej_wininterp;
		else
			% list all trials referenced in wininterp
			wininterp_trial_inds = round(wininterp(:,1)'/EEG.pnts)+1;
			% initialize marks to remove
			rm_inds = false(1,length(wininterp_trial_inds)); 
			% overwrites old wininterp with rejmanual except for single channel marks
			for rej_trial_ind = rej_trial_inds
				rm_inds = rm_inds | wininterp_trial_inds==rej_trial_ind; 
			end
			% removes any marks found in rejmanual but keeps single channel marks
			wininterp(rm_inds,:) = [];
			% add back in marks found in rejmanual
			wininterp = [wininterp; rej_wininterp];
			wininterp = sortrows(unique(wininterp,'rows'),1);
		end
	end

	eegplot(EEG.data,...
		'command', 'cb_updatemarks',...
		'events', EEG.event,...
		'srate', EEG.srate,...
		'limits', [EEG.xmin EEG.xmax]*1000,...
		'eloc_file', EEG.chanlocs,...
		'winrej', wininterp,...
		'wincolor', [1 1 .783],...
		'butlabel', 'UPDATE MARKS',...
		'title', ['Right-click to mark channels for interpolation within desired epochs -- ', EEG.setname],...
		'ctrlselectcommand', { 'cb_ctrlcmd;', '', '' }...
		);

% [1 1 1] red single channel trial
% [1 1 .783] whole epoch
% eegplot reject via inspection function goes from 1 to 701 but switches to 0 to 700
% native function below attempts conversion but doesn't work
% trial2eegplot(EEG.reject.rejmanual, EEG.reject.rejmanualE, EEG.pnts, [1 1 0.783])
