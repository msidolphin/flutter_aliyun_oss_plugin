typedef OnUploadSuccess = void Function(String url);

typedef OnUploadFailure = void Function(String message);

typedef OnProgress = void Function(int currentSize, int totalSize);

class PutObjectEventHandler {

  OnUploadSuccess onSuccess;
  OnUploadFailure onFailure;
  OnProgress onProgress;

}