# Bundled UI font

Unmodified Vazirmatn v33.003, full Persian/Arabic + Latin TTF variant, weights
400 (Regular), 500 (Medium), and 600 (SemiBold). These match the prototype's
body, Material label, and heading weights. Static files provide explicit weight mappings and include only the three used
weights.

Official source: https://github.com/rastikerdar/vazirmatn/tree/v33.003/fonts/ttf

License: SIL Open Font License 1.1; the original copyright notice and full terms
are preserved in OFL.txt and included as an application asset. Keep this notice
and license with redistributed fonts. Fonts have not been subsetted or renamed.

SHA-256:

- Regular: b69fd4c680b8f3f225feabcc655a2c585d97627b8f5f5c0f9985e894069f3a56
- Medium: b986623e4ddef10755e04be39f8ea7bcb1dc08bfe8dd0aa6af395736f256ad4a
- SemiBold: 3f239d8364c14ee32c46b6839fa197c28958358b82a9673d2c6acc8506d78bc5

ThemeData selects this family centrally. Flutter Web loads declared font assets
before application rendering; Persian no longer needs the asynchronous remote
Noto fallback used by the original prototype. This does not disable Flutter's
engine-default Roboto download or fallback for characters outside this family.
