import React from 'react';
import Layout from '../components/layout/Layout';
import { useAuth } from '../contexts/AuthContext';

const Dashboard: React.FC = () => {
  const { user } = useAuth();

  return (
    <Layout>
      <div className="space-y-6">
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-2xl font-bold mb-4">Welcome, {user?.email}!</h2>
          <p className="text-gray-600">
            This is your protected dashboard. Only authenticated users can see this page.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Example dashboard widgets */}
          <div className="bg-white shadow rounded-lg p-6">
            <h3 className="text-lg font-semibold mb-2">Quick Stats</h3>
            <p className="text-gray-600">Your activity overview goes here.</p>
          </div>
          
          <div className="bg-white shadow rounded-lg p-6">
            <h3 className="text-lg font-semibold mb-2">Recent Activity</h3>
            <p className="text-gray-600">Your recent actions will be displayed here.</p>
          </div>
          
          <div className="bg-white shadow rounded-lg p-6">
            <h3 className="text-lg font-semibold mb-2">Notifications</h3>
            <p className="text-gray-600">Your notifications will appear here.</p>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default Dashboard; 