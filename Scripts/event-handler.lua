-- function OnStoredInstance(instanceId, tags, metadata)
--     -- 1. Ambil Accession Number dari gambar yang baru masuk
--     local accessionNumber = tags['AccessionNumber']

--     -- Cek jika Accession Number ada (tidak kosong)
--     if accessionNumber ~= nil and accessionNumber ~= "" then

--         local config = GetOrthancConfiguration()
--         local ris = config['RIS']['Host']
--         local url = ris .. '/api/orthanc/on-stored-instance'

--         local payload = DumpJson({
--             ["AccessionNumber"] = accessionNumber,
--             ["InstanceID"] = instanceId,
--             ["PatientID"] = tags['PatientID']
--         }, true)

--         PrintRecursive('Mengingirim notifikasi ke RIS untuk ACC: ' .. accessionNumber)
--         HttpPost(url, payload, {['Content-Type'] = 'application/json'})

--     end
-- end

function OnStableStudy(studyId, tags, metadata)
    -- Ambil konfigurasi URL dari orthanc.json
    local config = GetOrthancConfiguration()
    local risHost = config['RIS']['Host']
    local url = risHost .. '/api/orthanc/on-stable-study'

    print('Processing Stable Study: ' .. studyId)

    local study = ParseJson(RestApiGet('/studies/' .. studyId))
    local modality = tags['ModalitiesInStudy']

    -- Jika ModalitiesInStudy tidak ditemukan (nil atau kosong), cari manual dari Series
    if (modality == nil or modality == "") then
        local seriesList = study['Series']
        if (seriesList and #seriesList > 0) then
            local firstSeriesId = seriesList[1]
            local seriesData = ParseJson(RestApiGet('/series/' .. firstSeriesId))
            if seriesData['MainDicomTags'] then
                modality = seriesData['MainDicomTags']['Modality']
                print('Found Modality from Series: ' .. (modality or 'Unknown'))
            end
        end
    end

    study['Modality'] = modality;

    print('Mengirim Data Study ke RIS untuk ACC: ' .. (tags['AccessionNumber'] or 'Unknown'))

    HttpPost(url, DumpJson(study), {['Content-Type'] = 'application/json'})
end