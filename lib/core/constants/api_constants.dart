class ApiConstants {
  static const baseUrl =
      "https://ekg.api.virtualdoc.akdndhrc.org/api";
  static const fileBaseUrl =
      "https://ekg.api.virtualdoc.akdndhrc.org";

  // Auth / Patient
  static const insertPatient = "$baseUrl/authentication/Insert-patient";
  static const getPatientById =
      "$baseUrl/Patient/get-patient-by-id";
  static const loginUser =
      "$baseUrl/Authentication/login-user";

  // ECG
  static const uploadEcg =
      "$baseUrl/ECG/insert-ecg-file-upload";
  static const getSymptoms =
      "$baseUrl/SystemValues/get-system-value-by-type";
  static const allDoctors =
      "$baseUrl/Doctor/get-doctors-by-Team";
  static const allHospitals =
      "$baseUrl/Hospital/fetch-all-hospitals";
  static const reviewTab =
      "$baseUrl/ECG/get-approved-or-pending-ecgs";
  static const historyTab =
      "$baseUrl/ECG/get-by-patientid";

}
