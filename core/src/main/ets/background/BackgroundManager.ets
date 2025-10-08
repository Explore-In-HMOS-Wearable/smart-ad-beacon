import { wantAgent, common } from '@kit.AbilityKit'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { hilog } from '@kit.PerformanceAnalysisKit'
import { LogManager } from '../logger/LogManager'

const TAG = 'BackgroundManager'

export class BackgroundManager {
  /**
   * Starts the background task to keep beacon scanning alive.
   * @param context Application UIAbilityContext
   */
  public static startBeaconBackgroundTask(context?: common.UIAbilityContext): void {
    if (!context) {
      LogManager.error(TAG,`UIAbilityContext is undefined.`)
      return
    }

    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: context.abilityInfo.bundleName,
          abilityName: context.abilityInfo.name
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    }

    wantAgent.getWantAgent(wantAgentInfo).then((agent) => {
      backgroundTaskManager.startBackgroundRunning(
        context,
        backgroundTaskManager.BackgroundMode.BLUETOOTH_INTERACTION, // En düşük etkileşimli mod
        agent
      ).then(() => {
        LogManager.info(TAG,`Background task started.`)
      }).catch((error: BusinessError) => {
        LogManager.error(TAG,`Failed to start background task. Code: ${error.code}, Msg: ${error.message}`)
      })
    }).catch((error: BusinessError) => {
      LogManager.error(TAG,`WantAgent creation failed. Code: ${error.code}, Msg: ${error.message}`)
    })
  }

  /**
   * Stops the background task when beacon scanning is no longer needed.
   * @param context Application UIAbilityContext
   */
  public static stopBeaconBackgroundTask(context: common.UIAbilityContext): void {
    backgroundTaskManager.stopBackgroundRunning(context).then(() => {
      LogManager.info(TAG,`Background task stopped.`)
    }).catch((error: BusinessError) => {
      LogManager.error(TAG,`Failed to stop background task. Code: ${error.code}`)
    })
  }
}
