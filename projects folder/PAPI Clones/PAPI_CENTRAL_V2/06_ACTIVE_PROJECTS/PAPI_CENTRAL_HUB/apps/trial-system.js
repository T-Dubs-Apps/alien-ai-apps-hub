// trial-system.js — PAPI Trial & Access System
// Manages trial periods and access grants for PAPI apps
(function() {
  'use strict';
  const MASTER_KEY = localStorage.getItem('master_admin');
  const isMaster   = MASTER_KEY === 'TROY_WALKER_2026';

  window.TrialSystem = {
    isActive: function(appId) {
      if (isMaster) return true;
      const key   = 'trial_' + appId;
      const start = localStorage.getItem(key);
      if (!start) { localStorage.setItem(key, Date.now()); return true; }
      const elapsed = (Date.now() - parseInt(start, 10)) / 1000 / 60 / 60 / 24;
      return elapsed < 7; // 7-day trial
    },
    getRemainingDays: function(appId) {
      if (isMaster) return Infinity;
      const start = localStorage.getItem('trial_' + appId);
      if (!start) return 7;
      const elapsed = (Date.now() - parseInt(start, 10)) / 1000 / 60 / 60 / 24;
      return Math.max(0, Math.ceil(7 - elapsed));
    },
    grantAccess: function(appId) {
      localStorage.setItem('app_owned_' + appId, '1');
    },
    hasAccess: function(appId) {
      if (isMaster) return true;
      return localStorage.getItem('app_owned_' + appId) === '1' || this.isActive(appId);
    }
  };
})();
