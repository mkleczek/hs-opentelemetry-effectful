module Effectful.OpenTelemetry where

import Data.Text (Text)
import Effectful (Dispatch (Static), DispatchOf, Eff, Effect, IOE, (:>))
import Effectful.Dispatch.Static (SideEffects (WithSideEffects), StaticRep, evalStaticRep, unEff, unsafeEff)
import OpenTelemetry.Trace.Core qualified as OT

data OpenTelemetry :: Effect

type instance DispatchOf OpenTelemetry = 'Static 'WithSideEffects
newtype instance StaticRep OpenTelemetry = OpenTelemetry ()

runOpenTelemetry :: IOE :> es => Eff (OpenTelemetry : es) a -> Eff es a
runOpenTelemetry = evalStaticRep (OpenTelemetry ())

inSpan :: OpenTelemetry :> es => OT.Tracer -> Text -> OT.SpanArguments -> Eff es a -> Eff es a
inSpan tracer name args m = unsafeEff $ \env -> OT.inSpan tracer name args $ unEff m env
