function EEG = update_wn_with_wininterp(EEG)
  if ~isfield(EEG.etc,'wininterp') || isempty(EEG.etc.wininterp)
    EEG.etc.wininterp = [];
    EEG.etc.wn = [];
    return;
  end
	% make etc.wn, which is just an easier variable to work with
  % epoch #, color, channel (0 if whole epoch)
	wn = EEG.etc.wininterp;
	ch = [];
	for i = 1:size(wn,1)
		chi = find(wn(i,6:end)); % ignores color, only looks for any chs marked
		if isempty(chi); chi = 0; end
		ch(i,:) = chi;
	end
	wnt = [round(wn(:,2)/EEG.pnts), wn(:,5), ch];
  EEG.etc.wn = wnt;
