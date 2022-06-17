function EEG = update_wininterp_with_wn(EEG)
  % this function should usually not be used
	if ~isfield(EEG.etc,'wininterp') || isempty(EEG.etc.wininterp)
		wininterp = []; 
	else
		wininterp = EEG.etc.wininterp;
  end
  rej_trial_inds = false(1,EEG.trials);
  rej_trial_inds(EEG.etc.wn(:,1)) = true;
  rej_trial_inds = find(rej_trial_inds);
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
    % add rejmanual marks, but keep single channel marks
    wininterp_trial_inds = round(wininterp(:,1)'/EEG.pnts)+1;
    rm_inds = false(1,length(wininterp_trial_inds)); %preinit
    for rej_trial_ind = rej_trial_inds
      rm_inds = rm_inds | wininterp_trial_inds==rej_trial_ind;
    end
    wininterp(rm_inds,:) = []; % remove all old marks
    wininterp = [wininterp; rej_wininterp]; % add new from rejmanual only
    wininterp = sortrows(unique(wininterp,'rows'),1);
  end
  
  EEG.etc.wininterp = wininterp;