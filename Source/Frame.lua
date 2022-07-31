PreserveAuctionatorAHScanDataFrameMixin = {}

function PreserveAuctionatorAHScanDataFrameMixin:OnLoad()
  FrameUtil.RegisterFrameForEvents(self, {
    "PLAYER_LOGIN"
  })
end

function PreserveAuctionatorAHScanDataFrameMixin:ReceiveEvent(eventName, eventData)
  if eventName == Auctionator.FullScan.Events.ScanComplete then
    PRESERVE_AUCTIONATOR_AH_SCAN_LAST_SCAN = {
      realm = Auctionator.Variables.GetConnectedRealmRoot(),
      data = eventData,
    }
  end
end

function PreserveAuctionatorAHScanDataFrameMixin:OnEvent(event, ...)
  if event == "PLAYER_LOGIN" then
    Auctionator.EventBus:Register(self, {
      Auctionator.FullScan.Events.ScanComplete
    })
  end
end
