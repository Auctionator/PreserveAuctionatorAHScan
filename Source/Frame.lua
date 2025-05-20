PreserveAuctionatorAHScanDataFrameMixin = {}

function PreserveAuctionatorAHScanDataFrameMixin:OnLoad()
  FrameUtil.RegisterFrameForEvents(self, {
    "PLAYER_LOGIN"
  })
end

function PreserveAuctionatorAHScanDataFrameMixin:ReceiveEvent(eventName, eventData)
  if Auctionator.FullScan and Auctionator.FullScan.Events and eventName == Auctionator.FullScan.Events.ScanComplete then
    PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SCAN = {
      realm = Auctionator.Variables.GetConnectedRealmRoot(),
      time = time(),
      data = eventData,
    }
    PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SUMMARY = nil
  elseif Auctionator.IncrementalScan and Auctionator.IncrementalScan.Events and eventName == Auctionator.IncrementalScan.Events.ScanComplete then
    PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SUMMARY = {
      realm = Auctionator.Variables.GetConnectedRealmRoot(),
      time = time(),
      data = eventData,
    }
    PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SCAN = nil
  end
end

local function removeAgedData()
  local now, maxAge = time(), 60 * 60
  for _, v in ipairs({ "PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SCAN", "PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SUMMARY" }) do
    if _G[v] and _G[v].data and (not _G[v].time or now - _G[v].time > maxAge) then
      wipe(_G[v])
      -- print(format("Preserve Auctionator AH Scan: Removed scan data for Collectionator that was over %d minutes old.", maxAge / 60))
    end
  end
end

function PreserveAuctionatorAHScanDataFrameMixin:OnEvent(event, ...)
  if event == "PLAYER_LOGIN" then
    if Auctionator.FullScan and Auctionator.FullScan.Events then
      Auctionator.EventBus:Register(self, {
        Auctionator.FullScan.Events.ScanComplete
      })
    end

    if Auctionator.IncrementalScan and Auctionator.IncrementalScan.Events then
      Auctionator.EventBus:Register(self, {
        Auctionator.IncrementalScan.Events.ScanComplete
      })
    end
  end
  removeAgedData()
end
