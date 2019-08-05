# AWS Lambda functions should require this file to configure the XRay.recorder
# for use within the function.

require_relative '../aws-xray-sdk'
require_relative 'lambda/facade_segment'
require_relative 'lambda/lambda_context'
require_relative 'lambda/lambda_emitter'
require_relative 'lambda/lambda_streamer'

# Set `XRAY_LAMBDA_PATCH_CONFIG` before requiring `aws-xray-sdk/lambda`
# to configure which libraries (if any) they want to have instrumented.
#
# By default, both `net_http` and `aws_sdk` will be instrumented
unless defined? XRAY_LAMBDA_PATCH_CONFIG
  XRAY_LAMBDA_PATCH_CONFIG = %I[net_http aws_sdk]
end

# Configure the XRay.recorder with Lambda specific config.
#
# From here, a lambda may create subsegments manually, or via the instrumented libraries
# setup by XRAY_LAMBDA_PATCH_CONFIG
XRay.recorder.configure(
  patch: XRAY_LAMBDA_PATCH_CONFIG,
  context: XRay::LambdaContext.new,
  streamer: XRay::LambdaStreamer.new,
  emitter: XRay::LambdaEmitter.new
)
