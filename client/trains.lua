if Config.Trains then
    SwitchTrainTrack(0, true) -- Setting the Main train track(s) around LS and towards Sandy Shores active
    SetTrainTrackSpawnFrequency(0, 120000) -- The Train spawn frequency set for the game engine
    SetRandomTrains(true) -- Telling the game we want to use randomly spawned trains
end