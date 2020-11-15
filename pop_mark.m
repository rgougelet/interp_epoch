function EEG = pop_mark(EEG)
	if ~isfield(EEG.etc,'wininterp') || isempty(EEG.etc.wininterp)
		wj = []; 
	else
		wj = EEG.etc.wininterp;
	end

	% this helps integrate with native functionality marked whole epcohs
% 	if ~isempty(EEG.reject.rejmanual)
% 		fi = find(EEG.reject.rejmanual);
% 		strtstp = [0 EEG.pnts-1]+(fi-1)'*EEG.pnts;
% 		
% %  		strtstp(strtstp==0) = 1;
% 		wcol = [strtstp, repmat([1 1 .783], length(fi), 1), zeros(length(fi), EEG.nbchan)];
% 		whole_trials = all(wj(:,3:5)==[1 1 .783],2);
% 		wj(whole_trials,:) = []; % remove old whole trials, add updated ones
% 		wj = [wj; wcol];
% 		wj = unique(wj, 'rows');
% % 		list_of_trials_marked = round(wj(:,1)/EEG.pnts)+1;
% % 		whole_trials = all(wj(:,3:5)==[1 1 .783],2);
% % 		wj([false; ~diff(list_of_trials_marked(whole_trials))],:) = [];
% 	end

% wj = [wj; trial2eegplot(EEG.reject.rejmanual, EEG.reject.rejmanualE, EEG.pnts, [1 1 0.783])];
% wj = unique(wj, 'rows');

% [1 1 1] red single channel trial
% [1 1 .783] whole epoch
% eegplot reject via inspection function goes from 1 to 701 but switches to 0 to 700

	eegplot(EEG.data,...
		'command', 'cb_updatemarks',...
		'events', EEG.event,...
		'srate', EEG.srate,...
		'limits', [EEG.xmin EEG.xmax]*1000,...
		'eloc_file', EEG.chanlocs,...
		'winrej', wj,...
		'wincolor', [1 1 .783],...
		'butlabel', 'UPDATE MARKS',...
		'title', ['Right-click to mark channels for interpolation within desired epochs -- ', EEG.setname],...
		'ctrlselectcommand', { 'cb_ctrlcmd;', '', '' }...
		);

