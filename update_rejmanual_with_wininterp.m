function EEG = update_rejmanual_with_wininterp(EEG)

	% update rejmanual for removing whole trials
	rejm = false(1,EEG.trials);
	list_of_trials_marked = round(EEG.etc.wininterp(:,1)/EEG.pnts)+1;
	whole_trials = all(EEG.etc.wininterp(:,3:5)==[1 1 .783],2);
	rejm(unique(list_of_trials_marked(whole_trials)))=true;
	EEG.reject.rejmanual = rejm;
	EEG.etc.wininterp(whole_trials,:) = [];
	EEG.etc.rejmanual = rejm;