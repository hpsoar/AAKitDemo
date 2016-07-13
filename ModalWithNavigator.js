'use strict';

var React = require('react');

import { StyleSheet, View, Text, NavigatorIOS, NativeModules, } from "react-native"; 

import { NativeAppEventEmitter } from 'react-native';

var SimpleList = require('./SimpleList');
var SimpleView = require('./SimpleView');

var RNBridge = require('react-native-controller-bridge');

var data = [
    'react-native push',
    'Two',
    'Three',
]

console.log('hi');

class ModalWithNavigator extends React.Component{
  constructor(props) {

    super(props);
    this.state = {subscription: false};
    this.controller = RNBridge.Controller(props.rn_controllerId);
  }
  componentDidMount() {
    console.log('mount');
    var subscription = NativeAppEventEmitter.addListener('testEvent', function(reminder) {
      console.log('777');
      console.log(reminder);
    });
    this.setState({ subscription: subscription });
    console.log(this.state);
  }

  componentWillUnmount() {
    this.state.subscription.remove();
  }

    _handleButton() {
      console.log('hi');
      this.controller.pop(true);
    }

    _next() {
      this.controller.push({
        title: 'hello',
        component: 'ModalWithNavigator',
        test: function(o) {
          console.log('hello:');
          console.log(o);
        },
        style: {
          hideNavigationBar: true,
          hideNavigationBarAnimated: false,
        }
      }, true);
    }

    _handleRowPress() {
        this.refs.navigator.push({
            title: 'Simple View',
            component: SimpleView,
        });
    }

    render() {
        return (
            <NavigatorIOS
                ref="navigator"
                style={styles.container}
                initialRoute={{
                    title: 'Navigator',
                    component: SimpleList,
                    passProps: {
                        data: data,
                        rowPressed: this._handleRowPress.bind(this)
                    },
                    leftButtonTitle: 'Close',
                    onLeftButtonPress: this._handleButton.bind(this),
                    rightButtonTitle: 'RNNavigagor.push',
                    onRightButtonPress: this._next.bind(this),
                }}
            />
        );
    }
};

var styles = StyleSheet.create({
    container: {
        flex: 1,
    }
});

module.exports = ModalWithNavigator;
