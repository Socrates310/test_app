A Flutter project.

# ConnectX

ConnectX is a mobile application designed to provide **chatting and media transfer services without the need for internet or a SIM card**. The app facilitates direct peer-to-peer communication between devices over a **local network** or **Bluetooth**, allowing users to send text messages, share images, videos, and other media files, all while not requiring a traditional internet connection or a mobile service provider.

## Key Features

1. **Offline Messaging**:
    - Allows users to send and receive messages without an internet connection, relying on Bluetooth or a local Wi-Fi network (e.g., hotspot) to connect devices.

2. **Media Sharing**:
    - Enables users to transfer media files such as images, videos, and documents between devices within proximity.

3. **Peer-to-Peer (P2P) Communication**:
    - Utilizes **Bluetooth** or **Wi-Fi Direct** for secure and fast direct device-to-device communication.

4. **No SIM Card Required**:
    - Operates completely independent of a cellular network or a SIM card, making it ideal for scenarios where users do not have access to mobile data or a phone number.

5. **Group Chat**:
    - Supports multiple users in a group chat, allowing for more dynamic communication in peer-to-peer networks.

6. **File Transfer Protocol**:
    - Implements a seamless file transfer protocol that makes sending and receiving files straightforward and secure.

7. **User Profiles**:
    - Users can create a profile with a name, avatar, and other personalized settings to enhance the communication experience.

## Technical Details

- **Platform**: Flutter (for cross-platform development).
- **Backend**: The app uses **Bluetooth** or **Wi-Fi Direct** for communication and **Local Server** (optional) for synchronization.
- **Offline Features**: All core features are designed to work offline, relying only on local device-to-device connections.
- **UI/UX**: Focuses on simplicity and intuitive navigation for easy access to messaging and media sharing.

## Use Cases

- **Offline Communication**: Ideal for situations where there is no cellular network or Wi-Fi available, such as rural areas, during travel, or in disaster recovery zones.
- **Instant Local File Transfer**: Allows users to share files, photos, videos, or documents instantly with nearby devices without needing data services or the internet.
- **Private Networking**: Provides a secure way for users to interact in private groups or discussions without exposure to online threats.

## Technology Stack

- **Flutter**: Used for building the mobile application (cross-platform for iOS and Android).
- **Bluetooth/Wi-Fi Direct**: For local device communication without the need for internet.
- **Shared Preferences**: To store user settings and data (e.g., username).




