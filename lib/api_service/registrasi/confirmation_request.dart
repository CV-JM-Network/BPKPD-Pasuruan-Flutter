class ConfirmationRequest {
  final String kodeKonfirmasi;
  final String deviceId;

  ConfirmationRequest({required this.kodeKonfirmasi, required this.deviceId});

  Map<String, dynamic> toJson() => {
        'kode_konfirmasi': kodeKonfirmasi,
        'device_id': deviceId,
      };
}
