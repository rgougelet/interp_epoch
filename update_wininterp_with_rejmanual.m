function EEG = update_wininterp_with_rejmanual(EEG)
  % overwrites old rejmanual marks in wininterp with new marks 
  % e.g. if rejmanual was changed outside the plugin using EEGLAB gui, it
  % adds those changes to wininterp, thus overwriting single channel marks
  % or undoing whole epoch marks. update_rejmanual_with_wininterp should
  % be immediately called after this, usually when update marks is pressed
  if ~isfield(EEG.etc,'wininterp') || isempty(EEG.etc.wininterp)
		wininterp = []; 
	else
		wininterp = EEG.etc.wininterp;
  end
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
    % remove all old wininterp marks (sometimes more than one per trial)
    wininterp_trial_inds = round(wininterp(:,1)'/EEG.pnts)+1;
    rm_inds = false(1,length(wininterp_trial_inds));
    for rej_trial_ind = rej_trial_inds
      rm_inds = rm_inds | wininterp_trial_inds==rej_trial_ind;
    end
    wininterp(rm_inds,:) = [];
    
    % add new from rejmanual only, in wininterp/winrej format
    wininterp = [wininterp; rej_wininterp]; 
    wininterp = sortrows(unique(wininterp,'rows'),1);
  end
  
  EEG.etc.wininterp = wininterp;