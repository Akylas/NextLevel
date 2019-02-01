//
//  NextLevelProtocols.swift
//  NextLevel (http://nextlevel.engineering/)
//
//  Copyright (c) 2016-present patrick piemonte (http://patrickpiemonte.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import AVFoundation
import CoreVideo
#if USE_ARKIT
import ARKit
#endif

// MARK: - NextLevelDelegate Dictionary Keys

/// Delegate callback dictionary key for photo metadata
public let NextLevelPhotoMetadataKey = "NextLevelPhotoMetadataKey"

/// Delegate callback dictionary key for JPEG data
public let NextLevelPhotoJPEGKey = "NextLevelPhotoJPEGKey"

/// Delegate callback dictionary key for cropped JPEG data
public let NextLevelPhotoCroppedJPEGKey = "NextLevelPhotoCroppedJPEGKey"

/// Delegate callback dictionary key for raw image data
public let NextLevelPhotoRawImageKey = "NextLevelPhotoRawImageKey"

/// Delegate callback dictionary key for a photo thumbnail
public let NextLevelPhotoThumbnailKey = "NextLevelPhotoThumbnailKey"

// MARK: - NextLevelDelegate

/// NextLevel delegate, provides updates for authorization, configuration changes, session state, preview state, and mode changes.
@objc public protocol NextLevelDelegate: AnyObject {
    
    // permission
    @objc optional func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: AVMediaType)
    
    // configuration
    @objc optional func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration)
    
    // session
    @objc optional func nextLevelSessionWillStart(_ nextLevel: NextLevel)
    @objc optional func nextLevelSessionDidStart(_ nextLevel: NextLevel)
    @objc optional func nextLevelSessionDidStop(_ nextLevel: NextLevel)
    
    // session interruption
    @objc optional func nextLevelSessionWasInterrupted(_ nextLevel: NextLevel)
    @objc optional func nextLevelSessionInterruptionEnded(_ nextLevel: NextLevel)
    
    // mode
    @objc optional func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel)
    @objc optional func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel)
}

/// Preview delegate, provides update for
@objc public protocol NextLevelPreviewDelegate: AnyObject {
    
    // preview
    @objc optional func nextLevelWillStartPreview(_ nextLevel: NextLevel)
    @objc optional func nextLevelDidStopPreview(_ nextLevel: NextLevel)
    
}

/// Device delegate, provides updates on device position, orientation, clean aperture, focus, exposure, and white balances changes.
@objc public protocol NextLevelDeviceDelegate: AnyObject {
    
    // position, orientation
    @objc optional func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel)
    @objc optional func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation)
    
    // format
    @objc optional func nextLevel(_ nextLevel: NextLevel, didChangeDeviceFormat deviceFormat: AVCaptureDevice.Format)
    
    // aperture, lens
    @objc optional func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didChangeLensPosition lensPosition: Float)
    
    // focus, exposure, white balance
    @objc optional func nextLevelWillStartFocus(_ nextLevel: NextLevel)
    @objc optional func nextLevelDidStopFocus(_  nextLevel: NextLevel)
    
    @objc optional func nextLevelWillChangeExposure(_ nextLevel: NextLevel)
    @objc optional func nextLevelDidChangeExposure(_ nextLevel: NextLevel)
    
    @objc optional func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel)
    @objc optional func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel)
    
}

// MARK: - NextLevelFlashAndTorchDelegate

/// Flash and torch delegate, provides updates on active flash and torch related changes.
@objc public protocol NextLevelFlashAndTorchDelegate: AnyObject {
    
    @objc optional func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel)
    @objc optional func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel)
    
    @objc optional func nextLevelFlashActiveChanged(_ nextLevel: NextLevel)
    @objc optional func nextLevelTorchActiveChanged(_ nextLevel: NextLevel)
    
    @objc optional func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel)
    
}

// MARK: - NextLevelVideoDelegate

/// Video delegate, provides updates on video related recording and capture functionality.
/// All methods are called on the main queue with the exception of nextLevel:renderToCustomContextWithSampleBuffer:onQueue.
@objc public protocol NextLevelVideoDelegate: AnyObject {
    
    // video zoom
    @objc optional func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float)
    
    // video processing
    @objc optional func nextLevel(_ nextLevel: NextLevel, willProcessRawVideoSampleBuffer sampleBuffer: CMSampleBuffer, onQueue queue: DispatchQueue)
    @objc optional func nextLevel(_ nextLevel: NextLevel, renderToCustomContextWithImageBuffer imageBuffer: CVPixelBuffer, onQueue queue: DispatchQueue)
    
    // ARKit video processing
    @available(iOS 11.0, *)
    @objc optional  func nextLevel(_ nextLevel: NextLevel, willProcessFrame frame: AnyObject, pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, onQueue queue: DispatchQueue)
    
    // video recording session
    @objc optional  func nextLevel(_ nextLevel: NextLevel, didSetupVideoInSession session: NextLevelSession)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didSetupAudioInSession session: NextLevelSession)
    
    // clip start/stop
    @objc optional func nextLevel(_ nextLevel: NextLevel, didStartClipInSession session: NextLevelSession)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didCompleteClip clip: NextLevelClip, inSession session: NextLevelSession)
    
    // clip file I/O
    @objc optional func nextLevel(_ nextLevel: NextLevel, didAppendVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didSkipVideoSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession)
    
    @objc optional func nextLevel(_ nextLevel: NextLevel, didAppendVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didSkipVideoPixelBuffer pixelBuffer: CVPixelBuffer, timestamp: TimeInterval, inSession session: NextLevelSession)
    
    @objc optional func nextLevel(_ nextLevel: NextLevel, didAppendAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didSkipAudioSampleBuffer sampleBuffer: CMSampleBuffer, inSession session: NextLevelSession)
    
    @objc optional func nextLevel(_ nextLevel: NextLevel, didCompleteSession session: NextLevelSession)
    
    // video frame photo
    @objc optional func nextLevel(_ nextLevel: NextLevel, didCompletePhotoCaptureFromVideoFrame photoDict: [String : Any]?)
    
}

// MARK: - NextLevelPhotoDelegate

/// Photo delegate, provides updates on photo related capture functionality.
@objc public protocol NextLevelPhotoDelegate: AnyObject {
    
    @objc optional func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration)
    
    @objc optional func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String: Any]?, photoConfiguration: NextLevelPhotoConfiguration)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String: Any]?, photoConfiguration: NextLevelPhotoConfiguration)
    
    @objc optional func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel)
    
    @available(iOS 11.0, *)
    @objc optional func nextLevel(_ nextLevel: NextLevel, didFinishProcessingPhoto photo: AVCapturePhoto)
}

// MARK: - NextLevelDepthDataDelegate

#if USE_TRUE_DEPTH
/// Depth data delegate, provides depth data updates
@objc public protocol NextLevelDepthDataDelegate: AnyObject {
    
    @available(iOS 11.0, *)
    @objc optional func depthDataOutput(_ nextLevel: NextLevel, didOutput depthData: AVDepthData, timestamp: CMTime)
    
    @available(iOS 11.0, *)
    @objc optional func depthDataOutput(_ nextLevel: NextLevel, didDrop depthData: AVDepthData, timestamp: CMTime, reason: AVCaptureOutput.DataDroppedReason)
    
}
#endif

// MARK: - NextLevelPortraitEffectsMatteDelegate

/// Portrait Effects Matte delegate, provides portrait effects matte updates
@objc public protocol NextLevelPortraitEffectsMatteDelegate: AnyObject {
    
    @available(iOS 12.0, *)
    @objc optional func portraitEffectsMatteOutput(_ nextLevel: NextLevel, didOutput portraitEffectsMatte: AVPortraitEffectsMatte)
    
}

// MARK: - NextLevelMetadataOutputObjectsDelegate

/// Metadata Output delegate, provides objects like faces and barcodes
@objc public protocol NextLevelMetadataOutputObjectsDelegate: AnyObject {

    @objc optional func metadataOutputObjects(_ nextLevel: NextLevel, didOutput metadataObjects: [AVMetadataObject])
}
