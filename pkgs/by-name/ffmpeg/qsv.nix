# ffmpeg build for intel GPU. Supports *_qsv encoders
{
  ffmpeg,
}:
ffmpeg.override {
  # https://www.reddit.com/r/IntelArc/comments/1at6gk0/comment/kv8zaus/
  # https://trac.ffmpeg.org/wiki/Hardware/QuickSync
  withDrm = true;
  withGPL = true;
  withAom = true;
  withDav1d = true;
  withFdkAac = true;
  withFreetype = true;
  withOpus = true;
  withMp3lame = true;
  withVorbis = true;
  withX264 = true;
  withX265 = true;
  withPic = true;
  withUnfree = true; # This part is disabled
  withRuntimeCPUDetection = true;
  withVaapi = true;
  withVpl = true;
}
