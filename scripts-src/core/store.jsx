import thunk from 'redux-thunk';
import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import * as coreReducers from './reducers';
import compatibleComponentsReducer from '../containers/CompatibleComponents/reducers';


function initStore (initialState) {
	let middleware = [thunk];
	let enhancers = [];
	let composeEnhancers = compose;

	if (process.env.NODE_ENV === 'development') {
		const composeWithDevToolsExtension = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__;
		if (typeof composeWithDevToolsExtension === 'function') {
			composeEnhancers = composeWithDevToolsExtension;
		}
	}

	const allReducers = Object.assign({},
		{ compatibleComponents: compatibleComponentsReducer },
		coreReducers
	);

	const store = createStore(
		combineReducers(allReducers),
		initialState,
		composeEnhancers(
			applyMiddleware(...middleware),
			...enhancers
		)
	);
	store.asyncReducers = {};

	return store;
}


const store = initStore({

	// every page that contains any React code needs things like the i18n, constants etc. loaded. This section
	// is populate by init.jsx in the parent folder. All top-level connected components in the page call init
//	init: { // prereqs?
//		initialized: false,
//		errorInitializing: false,
//	},
//
//		isAuthenticated: false,
//		userInfo: {},
//		i18n: {},
//		constants: {
//			root_url: null,
//			root_dir: null,
//			data_source_url: null
//		},

//	// used for installation + upgrades. This contains all compatible component versions for the user's current
//	// Core version
//	compatibleComponents: {
//		loaded: false,
//		errorLoading: false,
//		error: '',
//		searchFilter: '',
//		core: {},
//		api: {},
//		modules: {},
//		visibleModulesByFolder: [],
//		themes: {},
//		visibleThemesByFolder: [],
//
//		// separate request per component, loaded on-demand
//		componentChangelogs: {}
//	}

	// in case the user's core version is out of date, this contains the list of components that are compatible
	// with the latest version of the core. This info is automatically downloaded via a second request if there's a
	// new core available
	//latestCompatibleComponents: {},
});

export default store;
