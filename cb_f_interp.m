function nEEG = cb_f_interp(oldEEG)
nEEG = oldEEG;
if (~isfield(nEEG.etc,'wininterp')) || isempty(nEEG.etc.wininterp)
	warning('No single-trial channels have been marked for interpolation')
	return;
end
if (~isfield(nEEG.etc,'interp')) 
  nEEG.etc.interp = {};
end
if ~isempty(nEEG.etc.interp)
	warning('Old interpolated data overwritten')
	nEEG.etc.interp = {};
end
f = waitbar(0,'Interpolating single-trial channels...','Name','cb_interp()',...
		'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
waitObject = onCleanup(@() delete(f));
disp('Interpolating single-trial channels...');
try
	nEEG.etc.wininterp = unique(nEEG.etc.wininterp, 'rows'); % remove duplicate rows
	nEEG.etc.wininterp = sortrows(nEEG.etc.wininterp);
	wininterp = nEEG.etc.wininterp;
	
  % do interpolation
	es = unique(ceil(wininterp(:, 2)/nEEG.pnts));
	ne = length(es);
	int_epochs = [];
	whole_epochs = [];
	was_canceled = false;
	
	for ei = 1:ne
		e = es(ei);
		% Check for clicked Cancel button
		if getappdata(f,'canceling')
			was_canceled = true;
			disp('Canceled.');
			delete(f);
			break
    end
    
		% Update waitbar and message
		if ~mod(ei, floor(ne/20))
			waitbar(ei/ne,f)
    end
    
    % identify marked whole trial vs. single channel within trial
    ewj = wininterp(ceil(wininterp(:, 2)/nEEG.pnts)==e, :);
    [~, chs, ~] = find(ewj(:, 6:end));

		if isempty(chs)
      whole_epochs(end+1) = e;
      continue;
    else
      int_epochs(end+1) = e;
    end
    % get single epoch to interpolate channels within
		evalc('ep_EEG = pop_select(oldEEG, ''trial'', e);');
		evalc('ep_EEG = eeg_interp(ep_EEG, chs, ''spherical'');');
    if sum(sum(nEEG.data(:,:,e) - ep_EEG.data))==0
      error;
    end
		nEEG.data(:,:,e) = ep_EEG.data; % overwrite old data with new interpolated
    
    for chi = 1:length(chs) % potential for multiple channels per epoch
      nEEG.etc.interp(end+1,:) = {e, chs(chi), nEEG.data(chs(chi),:,e), oldEEG.data(chs(chi),:,e)};
    end
	end
	if ~was_canceled
		disp('...done.');
		disp(['The following ',num2str(length(unique(int_epochs))),' epochs had at least one channel interpolated: ']);
    disp(sprintf([repmat('   %i',1,10) '\n'],unique(int_epochs))); %#ok<DSPS>
		if ~isempty(nEEG.reject.rejmanual) && sum(nEEG.reject.rejmanual)~=0
			fprintf(['\nSome whole epochs were manually marked for rejection. \n',...
						'Be sure to reject them in EEGLAB using the\n',...
						'EEGLAB GUI>Tools>Reject Epochs menu option.\n'])
		end
  end
  delete(f)
catch me
  delete(f)
  disp(getReport(me, 'extended', 'hyperlinks', 'on' ));
	error("Interpolating single-trial channels failed.");
end

%% trash
% 	%% this helps integrate with native functionality marked whole epochs
% 	% pop_mark overwrites rejmanual after "update marks" is pressed
% 	% the code below only changes anything if rejmanual was updated separately
%   % todo is to open a popup to ask if this should be done
% 	if ~isempty(EEG.reject.rejmanual)
% 		rej_trial_inds = find(EEG.reject.rejmanual);
% 		% convert rejmanual into winrej format
% 		strtstp = [0 EEG.pnts-1]+(rej_trial_inds-1)'*EEG.pnts;
% 		strtstp(strtstp==0) = 1;
% 		rej_wininterp = [strtstp,...
% 									repmat([1 1 .783],...
% 									length(rej_trial_inds), 1),...
% 									zeros(length(rej_trial_inds),...
% 									EEG.nbchan)];
% 		if isempty(wininterp)
% 			wininterp = rej_wininterp;
% 		else
% 			% list all trials referenced in old wininterp
% 			wininterp_trial_inds = round(wininterp(:,1)'/EEG.pnts)+1;
% 			% initialize marks to remove
% 			rm_inds = false(1,length(wininterp_trial_inds)); 
% 			% overwrites old wininterp with rejmanual except for single channel marks
% 			for rej_trial_ind = rej_trial_inds
% 				rm_inds = rm_inds | wininterp_trial_inds==rej_trial_ind; 
% 			end
% 			% removes any marks found in rejmanual but keeps single channel marks
% 			wininterp(rm_inds,:) = [];
% 			% add back in marks found in rejmanual
% 			wininterp = [wininterp; rej_wininterp];
% 			wininterp = sortrows(unique(wininterp,'rows'),1);
% 		end
%   end

% if (~isfield(EEG.etc,'wininterp')) || isempty(EEG.etc.wininterp)
% 	warning('No single-trial channels have been marked for interpolation')
% end
% nEEG = EEG;
% f = waitbar(0,'Interpolating single-trial channels...','Name','cb_interp()',...
% 		'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% try
% 	EEG.etc.wininterp = unique(EEG.etc.wininterp, 'rows'); % remove duplicate rows
% 	EEG.etc.wininterp = sortrows(EEG.etc.wininterp);
% 	wininterp = EEG.etc.wininterp;
% 
% %% 	% this helps integrate with native functionality marked whole epochs
% % 	if ~isempty(EEG.reject.rejmanual)
% % 		fi = find(EEG.reject.rejmanual);
% % 		strtstp = [0 EEG.pnts-1]+(fi-1)'*EEG.pnts;
% % 		strtstp(strtstp==0) = 1;
% % 		wcol = [strtstp, repmat([1 1 .783], length(fi), 1), zeros(length(fi), EEG.nbchan)];
% % 		whole_trials = all(wininterp(:,3:5)==[1 1 .783],2);
% % 		wininterp(whole_trials,:) = []; % remove old whole trials, add updated ones
% % 		wininterp = [wininterp; wcol];
% % 		wininterp = unique(wininterp, 'rows');
% % 	end
% % 
% % 	% overwrites the single channels if the same whole epoch is marked
% % 	unfirstcol = unique(wininterp(:,1));
% % 	for uniqsi = 1:length(unfirstcol)
% % 		startinds = unfirstcol(uniqsi)==wininterp(:,1);
% % 		% if less than two rows are found continue
% % 		if sum(startinds)<2 
% % 			continue;
% % 		else
% % 			% if a whole epoch is marked
% % 			if any(wininterp(startinds,5)==.783)
% % 				% remove single channels marked in same epoch
% % 				wininterp(wininterp(startinds,5)==1)=[];
% % 			end
% % 		end
% % 	end
% 
% 	%% this helps integrate with native functionality marked whole epochs
% 	% pop_mark overwrites rejmanual after "update marks" is pressed
% 	% the code below only does anything if rejmanual was updated separately
% 	if ~isempty(EEG.reject.rejmanual)
% 		rej_trial_inds = find(EEG.reject.rejmanual);
% 		% convert rejmanual into winrej format
% 		strtstp = [0 EEG.pnts-1]+(rej_trial_inds-1)'*EEG.pnts;
% 		strtstp(strtstp==0) = 1;
% 		rej_wininterp = [strtstp,...
% 									repmat([1 1 .783],...
% 									length(rej_trial_inds), 1),...
% 									zeros(length(rej_trial_inds),...
% 									EEG.nbchan)];
% 		if isempty(wininterp)
% 			wininterp = rej_wininterp;
% 		else
% 			% list all trials referenced in wininterp
% 			wininterp_trial_inds = round(wininterp(:,1)'/EEG.pnts)+1;
% 			% initialize marks to remove
% 			rm_inds = false(1,length(wininterp_trial_inds)); 
% 			% overwrites old wininterp with rejmanual except for single channel marks
% 			for rej_trial_ind = rej_trial_inds
% 				rm_inds = rm_inds | wininterp_trial_inds==rej_trial_ind; 
% 			end
% 			% removes any marks found in rejmanual but keeps single channel marks
% 			wininterp(rm_inds,:) = [];
% 			% add back in marks found in rejmanual
% 			wininterp = [wininterp; rej_wininterp];
% 			wininterp = sortrows(unique(wininterp,'rows'),1);
% 		end
% 	end
% 
% 	% do interpolation
% 	es = unique(ceil(wininterp(:, 2)/EEG.pnts));
% 	ne = length(es);
% 	int_epochs = [];
% 	whole_epochs = [];
% 	was_canceled = false;
% 	
% 	for ei = 1:ne
% 		e = es(ei);
% 		% Check for clicked Cancel button
% 		if getappdata(f,'canceling')
% 			was_canceled = true;
% 			disp('Canceled.');
% 			delete(f);
% 			clear nEEG
% 			break
% 		end
% 		% Update waitbar and message
% 		if ~mod(ei, floor(ne/20))
% 			waitbar(ei/ne,f)
% 		end
% 		evalc('ep_EEG = pop_select(EEG, ''trial'', e);');
% 		ewj = wininterp(ceil(wininterp(:, 2)/EEG.pnts)==e, :);
% 		[~, chs, ~] = find(ewj(:, 6:end)); % ignores whole trials marked for rejection
% 		if isempty(chs); whole_epochs(end+1) = e;
% 		else int_epochs(end+1) = e; end
% 		evalc('ep_EEG = eeg_interp(ep_EEG, chs, ''spherical'');');
% 		nEEG.data(:,:,e) = ep_EEG.data;
% 	end
% 	if ~was_canceled
% 		disp('...done.');
% 		disp(['The following ',num2str(length(unique(int_epochs))),' epochs had at least one channel interpolated: ']);
% 		disp(num2str(unique(int_epochs)))
% 		if ~isempty(EEG.reject.rejmanual) && sum(EEG.reject.rejmanual)~=0
% 			disp(['Manually marked whole epochs were detected. ',...
% 						'Be sure to reject them under the EEGLAB ',...
% 						'GUI>Tools>Reject Epochs menu option.'])
% 		end
% 	end
% catch me
% 	clear nEEG
% 	warning("Interpolating single-trial channels failed.");
% 	disp(getReport(me, 'extended', 'hyperlinks', 'on' ));
% end
% delete(f)
% 
% % 		% this helps integrate with native functionality marked whole epochs
% 		% pop_mark overwrites rejmanual after "update marks" is pressed
% 		% the code below only does anything if rejmanual was updated separately
% 		if ~isempty(EEG.reject.rejmanual)
% 			rej_trial_inds = find(EEG.reject.rejmanual);
% 			% convert rejmanual into winrej format
% 			strtstp = [0 EEG.pnts-1]+(rej_trial_inds-1)'*EEG.pnts;
% 			strtstp(strtstp==0) = 1;
% 			rej_wininterp = [strtstp,...
% 										repmat([1 1 .783],...
% 										length(rej_trial_inds), 1),...
% 										zeros(length(rej_trial_inds),...
% 										EEG.nbchan)];
% 			% list all trials referenced in wininterp
% 			wininterp_trial_inds = round(wininterp(:,1)'/EEG.pnts)+1;
% 
% 			if isempty(wininterp)
% 				wininterp = rej_wininterp;
% 			else
% 				% initialize marks to remove
% 				rm_inds = false(1,length(wininterp_trial_inds)); 
% 				% overwrites old wininterp with rejmanual except for single channel marks
% 				for rej_trial_ind = rej_trial_inds
% 					rm_inds = rm_inds | wininterp_trial_inds==rej_trial_ind; 
% 				end
% 				% removes any marks found in rejmanual but keeps single channel marks
% 				wininterp(rm_inds,:) = [];
% 				% add back in marks found in rejmanual
% 				wininterp = [wininterp; rej_wininterp];
% 				wininterp = sortrows(unique(wininterp,'rows'),1);
% 			end
% 		end
