/*import android.content.Context
import android.net.wifi.p2p.WifiP2pManager
import android.os.Handler
import android.os.Looper

class WifiDirectManager(private val context: Context) {
    private val wifiP2pManager: WifiP2pManager =
        context.getSystemService(Context.WIFI_P2P_SERVICE) as WifiP2pManager
    private val wifiP2pChannel: WifiP2pManager.Channel =
        wifiP2pManager.initialize(context, Looper.getMainLooper(), null)

    private val scanTimeout: Long = 15_000 // 15 seconds
    private var scanInProgress = false
    private val timeoutHandler = Handler(Looper.getMainLooper())

    fun startPeerDiscovery(onCompletion: (Boolean) -> Unit) {
        if (scanInProgress) return

        scanInProgress = true

        // Start peer discovery
        wifiP2pManager.discoverPeers(wifiP2pChannel, object : WifiP2pManager.ActionListener {
            override fun onSuccess() {
                // Peer discovery started successfully
            }

            override fun onFailure(reason: Int) {
                scanInProgress = false
                onCompletion(false)
            }
        })

        // Stop scanning after timeout
        timeoutHandler.postDelayed({
            wifiP2pManager.requestPeers(wifiP2pChannel) { peers ->
                scanInProgress = false
                onCompletion(peers.deviceList.isNotEmpty())
            }
        }, scanTimeout)
    }

    fun stopPeerDiscovery() {
        if (!scanInProgress) return
        scanInProgress = false
        timeoutHandler.removeCallbacksAndMessages(null)
        wifiP2pManager.stopPeerDiscovery(wifiP2pChannel, null)
    }
}*/
