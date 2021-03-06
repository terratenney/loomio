angular.module('loomioApp').factory 'DraftService', ($timeout, AppConfig) ->
  new class DraftService

    applyDrafting: (scope, model, watchFields) ->
      draftMode = ->
        model[model.constructor.draftParent]() && model.isNew()

      timeout = $timeout(->)
      scope.$watch ->
        _.map watchFields, (field) -> model[field]
      , ->
        return unless draftMode()
        $timeout.cancel(timeout)
        timeout = $timeout((-> model.updateDraft()), AppConfig.drafts.debounce)
      , true

      scope.restoreDraft = ->
        model.restoreDraft() if draftMode()

      scope.restoreRemoteDraft = ->
        model.fetchDraft().then(scope.restoreDraft) if draftMode()
      scope.restoreRemoteDraft()
