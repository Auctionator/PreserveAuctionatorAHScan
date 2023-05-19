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
      data = eventData,
    }
  elseif Auctionator.IncrementalScan and Auctionator.IncrementalScan.Events and eventName == Auctionator.IncrementalScan.Events.ScanComplete then
    PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SUMMARY = {
      realm = Auctionator.Variables.GetConnectedRealmRoot(),
      data = eventData,
    }
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
end
