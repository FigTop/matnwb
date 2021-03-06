classdef ElectricalSeriesIOTest < tests.system.PyNWBIOTest
    
    methods
        function addContainer(testCase, file) %#ok<INUSL>
            devnm = 'dev1';
            egnm = 'tetrode1';
            esnm = 'test_eS';
            devBase = '/general/devices/';
            ephysBase = '/general/extracellular_ephys/';
            devlink = types.untyped.SoftLink([devBase devnm]);
            eglink = types.untyped.ObjectView([ephysBase egnm]);
            etReg = types.untyped.ObjectView([ephysBase 'electrodes']);
            dev = types.core.Device();
            file.general_devices.set(devnm, dev);
            eg = types.core.ElectrodeGroup( ...
                'description', 'tetrode description', ...
                'location', 'tetrode location', ...
                'device', devlink);
            
            electrodes = util.createElectrodeTable();
            for i = 1:4
                electrodes.addRow(...
                    'x', 1, 'y', 2, 'z', 4,...
                    'imp', 1,...
                    'location', {'CA1'},...
                    'filtering', 0,...
                    'group', eglink, 'group_name', {egnm});
            end
            file.general_extracellular_ephys_electrodes = electrodes;
            
            file.general_extracellular_ephys.set(egnm, eg);
            es = types.core.ElectricalSeries( ...
                'data', [0:9;10:19], ...
                'timestamps', (0:9) .', ...
                'electrodes', ...
                types.hdmf_common.DynamicTableRegion(...
                'data', [0;2],...
                'table', etReg,...
                'description', 'the first and third electrodes'));
            file.acquisition.set(esnm, es);
        end
        
        function c = getContainer(testCase, file) %#ok<INUSL>
            c = file.acquisition.get('test_eS');
        end
    end
end

