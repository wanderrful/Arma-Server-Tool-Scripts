class CfgPatches {
	class sxf_library {
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		author = "sixtyfour";
		authorUrl = "";
		url="";
		version = 1.2;
		versionStr = "1.2";
		versionAr[] = {1,2};
	};
};

class CfgFunctions {
    class SXF_Utility {
		tag = "SXF_Utility";

        class GlobalFunctions {
            file = "\sxf_library\addons\functions\utility";

            class getPlayerClassName {};
            class getEntitiesByPrefix {};
			class disableArsenalSavingLoading {};
			class stripUnit {};
        };
		class ServerFunctions {
			file = "\sxf_library\addons\functions\utility";

			class defineClientSideFunctions { preInit = 1; };
		};
    };
	class SXF_Init {
		tag = "SXF_Init";

		class GlobalFunctions {
			file = "\sxf_library\addons\functions\init";

			// General init functions
			class initSpecialHotkeys {};
			class initTFRSettingsIfUsing {};
		};
		class ServerFunctions {
			file = "\sxf_library\addons\functions\init";

			// General init functions
			class initLoopMessage {};
			class initMissionTimer {};

			// Game Modes
        	class initSkirmishServer {};
		};
	};
	class SXF_ScenarioFlow {
		tag = "SXF_ScenarioFlow";
		
		class ServerFunctions {
			file = "\sxf_library\addons\functions\scenarioflow";

			class handleMissionCompleted {};
			class handleMissionFailed {};
			class handleObjectiveCompleted {};
		};
	};
};