import Vision

extension CGRect {
    public func rectForSize(_ size: CGSize) -> CGRect {
        var rect = VNImageRectForNormalizedRect(self, Int(size.width), Int(size.height) )
        rect.origin.y = size.height - rect.origin.y - rect.size.height
        return rect
    }
}

