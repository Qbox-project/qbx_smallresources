-- config.lua
return {
    blacklisted = {
        -- Aircraft
        [`SHAMAL`] = true,
        [`LUXOR`] = true,
        [`LUXOR2`] = true,
        [`JET`] = true,
        [`LAZER`] = true,
        [`TITAN`] = true,
        [`HYDRA`] = true,
        
        -- Military & Armed Vehicles
        [`RHINO`] = true,
        [`OPPRESSOR`] = true,
        [`OPPRESSOR2`] = true,
        [`technical3`] = true,
        [`insurgent3`] = true,
        [`apc`] = true,
        [`tampa3`] = true,
        [`khanjali`] = true,
        [`ruiner2`] = true,
        [`deluxo`] = true,
        
        -- Helicopters
        [`BUZZARD`] = true,
        [`BUZZARD2`] = true,
        [`ANNIHILATOR`] = true,
        [`SAVAGE`] = true,
        [`MAVERICK`] = true,
        [`hunter`] = true,
        [`akula`] = true,
        
        -- Special Vehicles
        [`FIRETRUK`] = true,
        [`MULE`] = true,
        [`AIRTUG`] = true,
        [`CAMPER`] = true,
        [`vigilante`] = true,
        [`barrage`] = true,
        [`caracara`] = true,
        [`menacer`] = true,
        [`scramjet`] = true,
        [`strikeforce`] = true,
        
        -- Blimps
        [`BLIMP`] = true,
        [`blimp3`] = true,
        
        -- Arena War Vehicles
        [`cerberus`] = true,
        [`cerberus2`] = true,
        [`cerberus3`] = true,
        [`scarab`] = true,
        [`scarab2`] = true,
        [`scarab3`] = true,
        [`rrocket`] = true,
        [`voltic2`] = true,
        
        -- Utility/Trailers
        [`trailersmall2`] = true,
        [`halftrack`] = true,
        
        -- Law Enforcement Peds
        [`s_m_y_ranger_01`] = true,
        [`s_m_y_sheriff_01`] = true,
        [`s_m_y_cop_01`] = true,
        [`s_f_y_sheriff_01`] = true,
        [`s_f_y_cop_01`] = true,
        [`s_m_y_hwaycop_01`] = true
    },
    settings = {
        cleanupInterval = 100,
        bucketLockDownMode = GetConvar('qbx:bucketlockdownmode', 'relaxed')
    }
}