module Deno.ChildProcess
  ( ChildProcess
  , CommandStatus
  , pid
  , status
  , stdin
  , stdout
  , stderr
  , kill
  ) where

import Prelude

import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), maybe)
import Data.Nullable (Nullable, toMaybe, toNullable)
import Deno.Signal (Signal(..))
import Effect (Effect)
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, mkEffectFn1, runEffectFn1, runEffectFn2, runEffectFn3)
import Web.Streams.ReadableStream (ReadableStream)
import Web.Streams.WritableStream (WritableStream)

foreign import data ChildProcess :: Type

type CommandStatus =
  { success :: Boolean
  , code :: Int
  , signal :: Maybe Signal
  }

type CommandStatusRaw =
  { success :: Boolean
  , code :: Int
  , signal :: Nullable String
  }

foreign import pid :: ChildProcess -> Int

foreign import _stdin :: EffectFn1 ChildProcess (WritableStream Uint8Array)
foreign import _stdout :: EffectFn1 ChildProcess (ReadableStream Uint8Array)
foreign import _stderr :: EffectFn1 ChildProcess (ReadableStream Uint8Array)

foreign import _status :: EffectFn3 ChildProcess (EffectFn1 CommandStatusRaw Unit) (EffectFn1 Error Unit) Unit

foreign import _kill :: EffectFn2 (Nullable String) ChildProcess Unit

signalToString :: Signal -> String
signalToString = case _ of
  SIGABRT -> "SIGABRT"
  SIGALRM -> "SIGALRM"
  SIGBREAK -> "SIGBREAK"
  SIGBUS -> "SIGBUS"
  SIGCHLD -> "SIGCHLD"
  SIGCONT -> "SIGCONT"
  SIGEMT -> "SIGEMT"
  SIGFPE -> "SIGFPE"
  SIGHUP -> "SIGHUP"
  SIGILL -> "SIGILL"
  SIGINFO -> "SIGINFO"
  SIGINT -> "SIGINT"
  SIGIO -> "SIGIO"
  SIGPOLL -> "SIGPOLL"
  SIGUNUSED -> "SIGUNUSED"
  SIGKILL -> "SIGKILL"
  SIGPIPE -> "SIGPIPE"
  SIGPROF -> "SIGPROF"
  SIGPWR -> "SIGPWR"
  SIGQUIT -> "SIGQUIT"
  SIGSEGV -> "SIGSEGV"
  SIGSTKFLT -> "SIGSTKFLT"
  SIGSTOP -> "SIGSTOP"
  SIGSYS -> "SIGSYS"
  SIGTERM -> "SIGTERM"
  SIGTRAP -> "SIGTRAP"
  SIGTSTP -> "SIGTSTP"
  SIGTTIN -> "SIGTTIN"
  SIGTTOU -> "SIGTTOU"
  SIGURG -> "SIGURG"
  SIGUSR1 -> "SIGUSR1"
  SIGUSR2 -> "SIGUSR2"
  SIGVTALRM -> "SIGVTALRM"
  SIGWINCH -> "SIGWINCH"
  SIGXCPU -> "SIGXCPU"
  SIGXFSZ -> "SIGXFSZ"

stringToSignal :: String -> Maybe Signal
stringToSignal = case _ of
  "SIGABRT" -> Just SIGABRT
  "SIGALRM" -> Just SIGALRM
  "SIGBREAK" -> Just SIGBREAK
  "SIGBUS" -> Just SIGBUS
  "SIGCHLD" -> Just SIGCHLD
  "SIGCONT" -> Just SIGCONT
  "SIGEMT" -> Just SIGEMT
  "SIGFPE" -> Just SIGFPE
  "SIGHUP" -> Just SIGHUP
  "SIGILL" -> Just SIGILL
  "SIGINFO" -> Just SIGINFO
  "SIGINT" -> Just SIGINT
  "SIGIO" -> Just SIGIO
  "SIGPOLL" -> Just SIGPOLL
  "SIGUNUSED" -> Just SIGUNUSED
  "SIGKILL" -> Just SIGKILL
  "SIGPIPE" -> Just SIGPIPE
  "SIGPROF" -> Just SIGPROF
  "SIGPWR" -> Just SIGPWR
  "SIGQUIT" -> Just SIGQUIT
  "SIGSEGV" -> Just SIGSEGV
  "SIGSTKFLT" -> Just SIGSTKFLT
  "SIGSTOP" -> Just SIGSTOP
  "SIGSYS" -> Just SIGSYS
  "SIGTERM" -> Just SIGTERM
  "SIGTRAP" -> Just SIGTRAP
  "SIGTSTP" -> Just SIGTSTP
  "SIGTTIN" -> Just SIGTTIN
  "SIGTTOU" -> Just SIGTTOU
  "SIGURG" -> Just SIGURG
  "SIGUSR1" -> Just SIGUSR1
  "SIGUSR2" -> Just SIGUSR2
  "SIGVTALRM" -> Just SIGVTALRM
  "SIGWINCH" -> Just SIGWINCH
  "SIGXCPU" -> Just SIGXCPU
  "SIGXFSZ" -> Just SIGXFSZ
  _ -> Nothing

convertCommandStatus :: CommandStatusRaw -> CommandStatus
convertCommandStatus raw =
  { success: raw.success
  , code: raw.code
  , signal: toMaybe raw.signal >>= stringToSignal
  }

status :: ChildProcess -> Aff CommandStatus
status childProcess = makeAff \cb ->
  let
    onSuccess = cb <<< Right <<< convertCommandStatus
    onError = cb <<< Left
  in
    runEffectFn3 _status childProcess (mkEffectFn1 onSuccess) (mkEffectFn1 onError) *> mempty

stdin :: ChildProcess -> Effect (WritableStream Uint8Array)
stdin = runEffectFn1 _stdin

stdout :: ChildProcess -> Effect (ReadableStream Uint8Array)
stdout = runEffectFn1 _stdout

stderr :: ChildProcess -> Effect (ReadableStream Uint8Array)
stderr = runEffectFn1 _stderr

kill :: Maybe Signal -> ChildProcess -> Effect Unit
kill maybeSignal childProcess =
  let signalString = maybe Nothing (Just <<< signalToString) maybeSignal
  in runEffectFn2 _kill (toNullable signalString) childProcess
