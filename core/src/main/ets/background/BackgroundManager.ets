import { wantAgent, common } from '@kit.AbilityKit'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { LogManager } from '../logger/LogManager'

const TAG = 'BackgroundManager'

export class BackgroundManager {
  private static running = false

  static startBeaconBackgroundTask(
    context?: common.UIAbilityContext
  ): void {
    if (!context) {
      LogManager.error(TAG, 'UIAbilityContext is undefined')
      return
    }

    if (BackgroundManager.running) {
      LogManager.warn(TAG, 'Background task already running')
      return
    }

    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [{
        bundleName: context.abilityInfo.bundleName,
        abilityName: context.abilityInfo.name
      }],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }

    wantAgent.getWantAgent(wantAgentInfo)
      .then(agent => {
        return backgroundTaskManager.startBackgroundRunning(
          context,
          backgroundTaskManager.BackgroundMode.BLUETOOTH_INTERACTION,
          agent
        )
      })
      .then(() => {
        BackgroundManager.running = true
        LogManager.info(TAG, 'Background task started')
      })
      .catch((error: BusinessError) => {
        LogManager.warn(
          TAG,
          `Background task not supported or failed. Code=${error.code}`
        )
      })
  }

  static stopBeaconBackgroundTask(
    context?: common.UIAbilityContext
  ): void {
    if (!context || !BackgroundManager.running) {
      return
    }

    backgroundTaskManager.stopBackgroundRunning(context)
      .then(() => {
        BackgroundManager.running = false
        LogManager.info(TAG, 'Background task stopped')
      })
      .catch((error: BusinessError) => {
        LogManager.error(
          TAG,
          `Failed to stop background task. Code=${error.code}`
        )
      })
  }
}
