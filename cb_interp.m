if ~isfield(EEG.etc,'wininterp') || isempty(EEG.etc.wininterp)
	warning('No single-trial channels have been marked for interpolation')
	return;
end
nEEG = EEG;
f = waitbar(0,'Interpolating single-trial channels...','Name','Interpolate',...
		'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
try
	EEG.etc.wininterp = unique(EEG.etc.wininterp, 'rows'); % remove duplicate rows
	wi = sortrows(EEG.etc.wininterp);
	es = unique(ceil(wi(:, 2)/EEG.pnts));
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
		ewi = wi(ceil(wi(:, 2)/EEG.pnts)==e, :);
		[~, chs, ~] = find(ewi(:, 6:end)); % ignores whole trials marked for rejection
		if isempty(chs); whole_epochs(end+1) = e;
		else int_epochs(end+1) = e; end
		evalc('ep_EEG = eeg_interp(ep_EEG, chs, ''spherical'');');
		nEEG.data(:,:,e) = ep_EEG.data;
	end
	if ~cnc
		disp('...done.');
		disp(['The following ',num2str(length(unique(int_epochs))),' epochs had at least one channel interpolated: ']);
		disp(num2str(unique(int_epochs)))
	end
catch me
	clear nEEG
	warning("Interpolating single-trial channels failed.");
	disp(getReport(me, 'extended', 'hyperlinks', 'on' ));
end
delete(f)


