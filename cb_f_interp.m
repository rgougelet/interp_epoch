function nEEG = cb_f_interp(EEG)

if (~isfield(EEG.etc,'wininterp')) || isempty(EEG.etc.wininterp)
	warning('No single-trial channels have been marked for interpolation')
	return;
end
nEEG = EEG;
f = waitbar(0,'Interpolating single-trial channels...','Name','cb_interp()',...
		'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
try
	EEG.etc.wininterp = unique(EEG.etc.wininterp, 'rows'); % remove duplicate rows
	EEG.etc.wininterp = sortrows(EEG.etc.wininterp);

	wininterp = EEG.etc.wininterp;

	% this helps integrate with native functionality marked whole epochs
	% pop_mark overwrites rejmanual after "update marks" is pressed
	% the code below only does anything if rejmanual was updated separately
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
	
	es = unique(ceil(wininterp(:, 2)/EEG.pnts));
	ne = length(es);
	int_epochs = [];
	whole_epochs = [];
	cnc = false;
	
	for ei = 1:ne
		e = es(ei);
		% Check for clicked Cancel button
		if getappdata(f,'canceling')
			cnc = true;
			disp('Canceled.');
			delete(f);
			clear nEEG
			break
		end
		% Update waitbar and message
		if ~mod(ei, floor(ne/20))
			waitbar(ei/ne,f)
		end
		evalc('ep_EEG = pop_select(EEG, ''trial'', e);');
		ewj = wininterp(ceil(wininterp(:, 2)/EEG.pnts)==e, :);
		[~, chs, ~] = find(ewj(:, 6:end)); % ignores whole trials marked for rejection
		if isempty(chs); whole_epochs(end+1) = e;
		else int_epochs(end+1) = e; end
		evalc('ep_EEG = eeg_interp(ep_EEG, chs, ''spherical'');');
		nEEG.data(:,:,e) = ep_EEG.data;
	end
	if ~cnc
		disp('...done.');
		disp(['The following ',num2str(length(unique(int_epochs))),' epochs had at least one channel interpolated: ']);
		disp(num2str(unique(int_epochs)))
		if ~isempty(EEG.reject.rejmanual) && sum(EEG.reject.rejmanual)~=0
			disp(['Manually marked whole epochs were detected. ',...
						'Be sure to reject them under the EEGLAB ',...
						'GUI>Tools>Reject Epochs menu option.'])
		end
	end
catch me
	warning("Interpolating single-trial channels failed.");
	disp(getReport(me, 'extended', 'hyperlinks', 'on' ));
end
delete(f)


