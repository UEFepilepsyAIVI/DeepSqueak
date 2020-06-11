# DeepSqueak-Screener

[![DOI](https://zenodo.org/badge/211337688.svg)](https://zenodo.org/badge/latestdoi/211337688)


> Fork of [DeepSqueak](https://github.com/DrCoffey/DeepSqueak) (Coffey, Marx, Neumaier, 2019), with additional functionalities for  screening of whole records for false positives, false negatives and incorrect ROIs.

![DeepSqueak-Screener 10](https://user-images.githubusercontent.com/49067627/71246029-9db38380-231e-11ea-8af4-c9c9c235c8c7.gif)


## Additions
- Free backward and forward movement along the record.
- Additional spectogram with a larger time window for call contextualization.
- Single Click on lower spectrogram to jump to that position.
- Single Click a location on the scroll bar in map mode = upper spectrogram jumps to that location in the file.
- Up Arrow = next timepoint in spectrogram, Down Arrow = previous timepoint in spectrogram.
- Shift + Click on detection to reject it.
- Select, move, and modify ROIs of detected calls:

![screenshot](https://i.postimg.cc/8C08C48V/EXAMPLE-02.png)

- Possibility to mark calls not detected by FRCNN.
- Black & white color map.
- Constant time and spectrogram scales.
- Possibility to modify time and spectrogram scales, Focus (upper spectrogram), Epoch (lower spectrogram).
- Sonic Visualizer export/import.
- Open Original DeepSqueak detections files.
- GUI tweaks.


## Credits: 
**Original DeepSqueak**: Coffey, K., Marx, R., & Neumaier, J.<br>
**Screener**: Lara-Valderrábano, L. and Ciszek, R.

