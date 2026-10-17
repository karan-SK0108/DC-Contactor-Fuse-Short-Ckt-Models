runID = Simulink.sdi.Run.create('New Cable Model Parameters');

vars = out.who;

for k = 1:numel(vars)

    sig = out.(vars{k});

    try
        sig.Name = vars{k};
        Simulink.sdi.addToRun(runID,'vars',sig,vars{k});
        fprintf('Imported: %s\n',vars{k});
    end

end

Simulink.sdi.view;